source libs/common.sh

before_build(){
    install_hugo_v122
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="2c71e449-5854-42ad-832f-217add76fc32"></script>' >>  layouts/partials/favicons.html

}

build(){

    
    sed -i 's|PATH=$(BIN_DIR):$(PATH) BRANCH=$(BRANCH) hack/import-flux2-assets.sh|GITHUB_USER=cncfstack GITHUB_TOKEN=${{secret.CNCFSTACK_GITHUB_TOKEN}} PATH=$(BIN_DIR):$(PATH) BRANCH=$(BRANCH) hack/import-flux2-assets.sh|g' Makefile
    #cat Makefile

    make yq
    make prereqs
    make gen-content
    #make production-build

    mkdir output
    hugo \
    --destination ./output \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://flux.website.cncfstack.com

}

save_return(){

    #echo "${workdir}/output&oss://cncfstack-flux" > ${workdir}/ret-data
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="fluxcd.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C output .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}


cd project_dir
if cat .git/config  |grep '/fluxcd/website.git' ;then
    echo "匹配到 flux"
    before_build
    build
    find_and_sed_v2 "./output"
    save_return 
fi
