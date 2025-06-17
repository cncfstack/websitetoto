source libs/common.sh

before_build(){

    # 添加网站访问统计
    cat > overrides/main.html <<EOF
{% extends "base.html" %}
{% block htmltitle %}
  <script defer src="https://umami.cncfstack.com/script.js" data-website-id="0695b382-99dc-4d85-b1bc-fd3256449a37"></script>
  <title>keptn</title>
{% endblock %}
EOF

    # 查询mkdocs.yml文件中是否有site_url行，如果没有就新添加一行，如果有无论什么值都直接进行替换
    grep 'site_url:' mkdocs.yml && sed -i "s|site_url:.*|site_url: 'https://keptn.website.cncfstack.com'|g" mkdocs.yml || echo "site_url: 'https://keptn.website.cncfstack.com'" >> mkdocs.yml

    cat mkdocs.yml
}

build(){
    log_info "build keptn"
    make docs-build
}


save_return(){
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="keptn.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C site .

    if [ ! -s ${tarfile} ];then
        log_error "keptn 站点构建失败"
    fi

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./site"
    save_return
}


cd project_dir
if cat .git/config  |grep '/keptn/lifecycle-toolkit.git' ;then
    echo "匹配到 keptn"
    before_build
    build
    after_build 
fi

