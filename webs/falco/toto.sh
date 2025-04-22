source libs/common.sh

before_build(){
    install_hugo_v108
    install_postcss
    make dependencies

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="8e3dd142-ae95-4964-a6b9-1bff4c3dffcf"></script>' >>  layouts/partials/hooks/head-end.html

}

build(){

    #npm run build:production

    log_info "开始进行网站构建"
    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://falco.website.cncfstack.com

}

save_return(){
    # ls -lha
    # echo "${workdir}/output&oss://cncfstack-falco" > ${workdir}/ret-data

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="falco.tgz"

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
if cat .git/config  |grep '/falcosecurity/falco-website.git' ;then
    echo "匹配到 falco"
    before_build
    build
    find_and_sed_v2 "./output"
    save_return 
fi
