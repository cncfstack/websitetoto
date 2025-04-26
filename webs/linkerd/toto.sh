source libs/common.sh

before_build(){

    install_hugo_v136_5
    install_postcss

    # 注点意文档在这个目录中
    cd linkerd.io
    
    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="0f50e996-f7be-49d6-bc58-0ac6174f5c34"></script>' >>  ./layouts/partials/head-meta.html

}


build(){

    hugo \
    --environment production \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://linkerd.website.cncfstack.com
    
}

save_return(){
    # ls -lha
    # pwd
    # echo "project_dir/output&oss://cncfstack-istio" > project_dir/ret-data

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="linkerd.tgz"

    # 进入到目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C public .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./public"
    save_return
}


cd project_dir
if cat .git/config  |grep '/linkerd/website.git' ;then
    echo "匹配到 linkerd"
    before_build
    build
    after_build
fi