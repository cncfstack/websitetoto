source libs/common.sh

before_build(){
    install_hugo_v145
    npm install 

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="9b8051a7-fd5d-4cec-b8fe-3e9ec82cfad1"></script>' >>  ./themes/geekboot/layouts/partials/favicons.html

}

build(){

    log_info "开始进行站点构建"
    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://crossplane.website.cncfstack.com

}

save_return(){

    #echo "${workdir}/output&oss://cncfstack-crossplane" > ${workdir}/ret-data
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="crossplane.tgz"

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
if cat .git/config  |grep '/crossplane/docs.git' ;then
    echo "匹配到 crossplane"
    before_build
    build
    find_and_sed_v2 "./output"
    save_return 
fi
