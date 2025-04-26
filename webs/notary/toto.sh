source libs/common.sh

before_build(){
    install_hugo_v83_1
    install_postcss

    # 安装依赖
    npm install

    # 获取一下git 子模块内容
    npm run preinstall

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="e2245cb1-9c47-4c63-9330-88f7e729f480"></script>' >>  ./layouts/partials/favicons.html

}

build(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://notary.website.cncfstack.com

}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="notary.tgz"

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
if cat .git/config  |grep '/notaryproject/notaryproject.dev.git' ;then
    echo "匹配到 notary"
    before_build
    build
    after_build
fi
