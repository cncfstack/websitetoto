source libs/common.sh

before_build(){
    install_hugo_v100_2
    install_postcss

    log_info "添加网站访问统计"
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="9f78fcf9-90dc-4597-8fb8-a2b26aaf7656"></script>' >>  layouts/partials/favicons.html
}


build(){

    #npm run build:production

    log_info "开售构建站点"
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

    #echo "${workdir}/output&oss://cncfstack-coredns" > ${workdir}/ret-data
    log_info "这行很重要，在其他关联项目中，文件名称必须要匹配"
    tarfile="coredns.tgz"

    log_info "进入到site目录后进行打包，这样是为了便于部署时解压"
    tar -czf ${tarfile} -C project_dir/output .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > project_dir/ret-data
}


cd project_dir
if cat .git/config  |grep '/coredns/coredns.io.git' ;then
    echo "=============================================> 匹配到 coredns"
    before_build
    build
    find_and_sed_v2 "./output"
    save_return 
fi 
cd -