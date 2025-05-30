source libs/common.sh

before_build(){

    install_hugo_v119
    install_postcss


    log_info "构建 JS"
    cd utils/webpack && npm install && npm run prod && cd -

    log_info "npm install 安装依赖软件"
    npm install 
    npm fund


    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="9b8051a7-fd5d-4cec-b8fe-3e9ec82cfad1"></script>' >>  ./themes/geekboot/layouts/partials/favicons.html

}

build(){
    log_info "开始进行站点构建"
    # mkdir output
    # hugo \
    # --destination ./output \
    # --cleanDestinationDir \
    # --environment production \
    # --minify \
    # --gc \
    # --enableGitInfo \
    # --baseURL https://crossplane.website.cncfstack.com
    CONTEXT=production
    export CONTEXT=production
    sed -i 's|--baseURL https://docs.crossplane.io/|--baseURL https://crossplane.website.cncfstack.com/|g' netlify_build.sh
    bash -x netlify_build.sh

    ls -lh
}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="crossplane.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C public .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}


after_build(){

    # 先进行文件替换
    filetoto "./public"

    # 处理完成后，进行推送
    save_return
}


cd project_dir
if cat .git/config  |grep '/crossplane/docs.git' ;then
    log_info "匹配到 crossplane"
    before_build
    build
    after_build
fi
