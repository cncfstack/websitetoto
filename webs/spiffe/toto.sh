source libs/common.sh

before_build(){

    # install_hugo_v68_3
    install_hugo_v68_3
    npm install
    # python pull_external.py

    # pipenv run python pull_external.py

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="86f12ca0-83a8-470a-af6c-6ba96d72998e"></script>' >>  layouts/partials/meta.html

}

build(){

    #npm run build:production

    # mkdir public
    # hugo \
    # --destination ./public \
    # --cleanDestinationDir \
	# --buildDrafts \
	# --buildFuture \
    # --minify \
    # --gc \
    # --enableGitInfo \
    # --baseURL https://spiffe.website.cncfstack.com
    make setup
    make production-build

}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="spiffe.tgz"

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
    filetoto "./public"
    save_return
}

cd project_dir
if cat .git/config  |grep '/spiffe/spiffe.io.git' ;then
    echo "匹配到 spiffe"
    before_build
    build
    after_build 
fi
