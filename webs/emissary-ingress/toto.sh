source libs/common.sh

before_build(){
    install_hugo_v145

    npm install
    npm run prepare

    ls -lha
    echo "------------------"
    ls -lhathemes/docsy/
    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="1f96240b-84a8-46d7-85ce-3396d889e9a7"></script>' >>  ./themes/docsy/layouts/partials/favicons.html

}

build(){

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://emissary-ingress.website.cncfstack.com

}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="emissary-ingress.tgz"

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
if cat .git/config  |grep '/emissary-ingress/emissary-ingress.dev.git' ;then
    echo "匹配到 emissary-ingress"
    before_build
    build
    after_build
fi
