source libs/common.sh

before_build(){
    # 添加网站访问统计
    cat > overrides/main.html <<EOF
{% extends "base.html" %}
{% block htmltitle %}
  <script defer src="https://umami.cncfstack.com/script.js" data-website-id="efec053d-80c8-422f-b0e4-bdaa970e370b"></script>
  <title>Loggie</title>
{% endblock %}
EOF

# 原项目中缺少site_url配置，导致sitemap没有正确构建出来
echo "site_url: 'https://logggie.website.cncfstack.com'" >> mkdocs.yml

}

build(){
    echo "after_loggie"
    sudo docker run --rm -v ${PWD}:/docs squidfunk/mkdocs-material  build

    # 特殊情况，在构建完成后的文件中包含emoji表情svg文件，这这构建前是不可知道的，所以在构建完成后再替换一次。
    find_and_sed
}


save_return(){
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="loggie.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C site .

    if [ ! -s ${tarfile} ];then
        log_error "Loggie 站点构建失败"
    fi

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./site"
    save_return
}


cd project_dir
if cat .git/config  |grep '/loggie-io/docs.git' ;then
    echo "匹配到 loggie"
    before_build
    build
    after_build 
fi

