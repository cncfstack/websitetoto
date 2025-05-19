source libs/common.sh

before_build(){
    install_hugo_v100_2
    install_postcss

    log_info "添加网站访问统计"
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="9f78fcf9-90dc-4597-8fb8-a2b26aaf7656"></script>' >>  themes/coredns/layouts/partials/favicon.html
}


build(){

    #npm run build:production

    log_info "开始构建站点"
    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://coredns.website.cncfstack.com

}

save_return(){
    log_info "这行很重要，在其他关联项目中，文件名称必须要匹配"
    tarfile="coredns.tgz"

    log_info "进入到site目录后进行打包，这样是为了便于部署时解压"
    tar -czf ${tarfile} -C output .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    # 这里传递数据给上层的调用，但是由于执行了 cd project_dir ，所以上层在获取文件时需要添加一层目录
    echo "project_dir/${tarfile}" > ret-data
}


after_build(){
    filetoto "./output"
    save_return
}

cd project_dir && log_info "进入到项目代码的目录中，后续的所有动作都是在项目的代码根目录下执行"
if cat .git/config  |grep '/coredns/coredns.io.git' ;then
    log_info "匹配到 coredns"
    before_build
    build
    after_build
fi 