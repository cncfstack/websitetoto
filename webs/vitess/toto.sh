source libs/common.sh

before_build(){

    npm install
    install_hugo_v120

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="de57cc57-0486-41d4-b717-09fec9182af6"></script>' >> layouts/partials/meta.html

}

build(){
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
    --baseURL https://vitess.website.cncfstack.com

}



save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="vitess.tgz"

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
if cat .git/config  |grep '/vitessio/website.git' ;then
    echo "匹配到 vitessio"
    before_build
    find_and_sed_v2 "./website-site"
    build
    save_return 
fi

