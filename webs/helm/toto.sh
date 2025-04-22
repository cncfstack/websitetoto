source libs/common.sh

before_build(){
    echo "install hugo"
    install_hugo

    # 安装 postCSS
    echo "install postCSS"
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="78a80c38-ac4e-4954-a169-909f40f35336"></script>' >>  themes/helm/layouts/partials/meta.html

}

build(){

    # 构建
    ./hugo \
    --cleanDestinationDir \
    --buildFuture \
    --noBuildLock \
    --minify \
    --printI18nWarnings \
    --printMemoryUsage \
    --printPathWarnings \
    --printUnusedTemplates \
    --templateMetrics  \
    --templateMetricsHints \
    --baseURL https://helm.website.cncfstack.com
}

save_return(){
    #echo "${workdir}/app&oss://cncfstack-helm" > ${workdir}/ret-data

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="helm.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C app .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}


cd project_dir
if cat .git/config  |grep '/helm/helm-www.git' ;then
    echo "匹配到 Helm"
    before_build
    find_and_sed
    build
    save_return 
fi
