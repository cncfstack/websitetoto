source libs/common.sh

before_build(){
    install_hugo_v139_3
    install_postcss
    npm install
    npm run prepare
    

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="4efc5a30-2d38-479a-ba78-6c5fe9b4b2a1"></script>' >>  layouts/partials/favicons.html

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
    --baseURL https://in-toto.website.cncfstack.com

}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="in-toto.tgz"

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
if cat .git/config  |grep '/in-toto/in-toto.io.git' ;then
    echo "匹配到 in-toto"
    before_build
    build
    find_and_sed_v2 "./output"
    save_return 
fi
