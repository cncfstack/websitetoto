source libs/common.sh

before_build(){
    install_hugo_v145
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="9e595152-e500-4016-a1d1-a0f2d6b94415"></script>' >>  ./layouts/partials/hooks/head-end.html

}

build(){

    #npm run build:production
    mkdir output
    hugo \
    --environment production \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://kyverno.website.cncfstack.com

}

save_return(){
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="kyverno.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C output .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./output"
    save_return
}

cd project_dir
if cat .git/config  |grep '/kyverno/website.git' ;then
    echo "匹配到 kyverno"
    before_build
    build
    after_build
fi
