source libs/common.sh

before_build(){

    # 在make prepare前需要对脚本就行fix改造
    # 无法获取随机值，任务会卡住知道超时
    sed -i 's#STASH_TOKEN=[^)]*)#STASH_TOKEN=AowSMQkCLCTVPCDXKu9Quvad6l21pA0x#g' load-docs.sh
    cat load-docs.sh

    make prepare

    npm i

    install_hugo_v74
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="d2323b72-657c-4da2-9371-67f8383fc2c8"></script>' >>  layouts/partials/favicon.html

}

build(){

    #npm run build:production

    CONTEXT=production
    export CONTEXT=production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --e production \
	--buildDrafts \
	--buildFuture \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://harbor.website.cncfstack.com

}

save_return(){
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="harbor.tgz"

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
if cat .git/config  |grep '/goharbor/website.git' ;then
    echo "匹配到 harbor"
    before_build
    build
    after_build
fi
