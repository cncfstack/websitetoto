source libs/common.sh

before_build(){

    # 添加网站访问统计
    cat > overrides/main.html <<EOF
{% extends "base.html" %}
{% block htmltitle %}
  <script defer src="https://umami.cncfstack.com/script.js" data-website-id="9dcf06d8-94ef-4d63-8e5c-cda75e58e8c8"></script>
  <title>argocd</title>
{% endblock %}
EOF

    # 查询mkdocs.yml文件中是否有site_url行，如果没有就新添加一行，如果有无论什么值都直接进行替换
    grep 'site_url:' mkdocs.yml && sed -i "s|site_url:.*|site_url: 'https://argocd.website.cncfstack.com'|g" mkdocs.yml || echo "site_url: 'https://argocd.website.cncfstack.com'" >> mkdocs.yml

}

build(){
    echo "after_argocd"
    sudo docker run --rm -v ${PWD}:/docs squidfunk/mkdocs-material  build
}


save_return(){
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="argocd.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C site .

    if [ ! -s ${tarfile} ];then
        log_error "argocd 站点构建失败"
    fi

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./site"
    save_return
}


cd project_dir
if cat .git/config  |grep '/argoproj/argo-cd.git' ;then
    echo "匹配到 argocd"
    before_build
    build
    after_build 
fi

