source libs/common.sh

before_build(){
 
    install_hugo_v120
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="8a773cf4-261d-4258-9adc-c8031b8f69ae"></script>' >>  layouts/partials/javascript.html

}

build(){
    echo "cloudevent"
     # 构建
    mkdir website-site

    ./hugo \
    --destination ./website-site \
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
    --baseURL https://cloudevents.website.cncfstack.com
}


save_return(){    
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="cloudevents.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C website-site .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}


cd project_dir
if cat .git/config  |grep '/cloudevents/cloudevents-web.git' ;then
    echo "匹配到 cloudevents"
    before_build
    find_and_sed_v2 website-site
    build
    save_return 
fi