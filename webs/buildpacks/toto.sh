source libs/common.sh

before_build(){

    # npm install
    # install_hugo_v120

    # # 添加网站访问统计
    # echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="de57cc57-0486-41d4-b717-09fec9182af6"></script>' >> layouts/partials/meta.html

    echo "before build skip"
}

build(){
    # mkdir website-site

    # ./hugo \
    # --destination ./website-site \
    # --cleanDestinationDir \
    # --buildFuture \
    # --noBuildLock \
    # --minify \
    # --printI18nWarnings \
    # --printMemoryUsage \
    # --printPathWarnings \
    # --printUnusedTemplates \
    # --templateMetrics  \
    # --templateMetricsHints \
    # --baseURL https://buildpacks.website.cncfstack.com

    make build

    log_warn "============================"
    ls -lh
}



save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="buildpacks.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C build .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./build"
    save_return
}

cd project_dir
if cat .git/config  |grep '/buildpacks/docs.git' ;then
    echo "匹配到 buildpacks"
    before_build
    build
    after_build
fi
