source libs/common.sh

before_build(){
    install_hugo_v145
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="fd31286b-b455-4b8c-8d83-549b2ab02cff"></script>' >>  layouts/partials/favicons.html

}

build(){

    #npm run build:production

    log_info "开始进行站点构建"
    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://etcd.website.cncfstack.com

}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="etcd.tgz"

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
if cat .git/config  |grep '/etcd-io/website.git' ;then
    echo "匹配到 etcd"
    before_build
    build
    cycle_sed "./output"
    save_return 
fi
