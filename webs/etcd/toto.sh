source libs/common.sh

before_build(){
    install_hugo_v145
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="fd31286b-b455-4b8c-8d83-549b2ab02cff"></script>' >>  layouts/partials/favicons.html

}

build(){

    #npm run build:production

    log_info "开始进行站点构建"
    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://etcd.website.cncfstack.com

}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="etcd.tgz"

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

    mkdir -p output/docs/latest/install
    latest_docs_dst=`cat output/_redirects |grep -w '/docs/latest'|grep -v splat|awk '{print $2}'`
    echo '<!doctype html><html lang=en><head><meta name=generator content="Hugo 0.145.0"><meta charset=utf-8><meta name=viewport content="width=device-width,initial-scale=1"><title>map[dest:'${latest_docs_dst}']</title><link rel=canonical href='$latest_docs_dst'><meta name=robots content="noindex"><meta http-equiv=refresh content="0; url='$latest_docs_dst'"></head></html>' > output/docs/latest/index.html
    echo '<!doctype html><html lang=en><head><meta name=generator content="Hugo 0.145.0"><meta charset=utf-8><meta name=viewport content="width=device-width,initial-scale=1"><title>map[dest:'${latest_docs_dst}']</title><link rel=canonical href='$latest_docs_dst'><meta name=robots content="noindex"><meta http-equiv=refresh content="0; url='$latest_docs_dst'"></head></html>' > output/docs/latest/install/index.html

    log_info "output/docs/latest/index.html"
    cat output/docs/latest/index.html

    log_info "output/docs/latest/install/index.html"
    cat output/docs/latest/install/index.html

    filetoto "./output"
    save_return
}


cd project_dir
if cat .git/config  |grep '/etcd-io/website.git' ;then
    echo "匹配到 etcd"
    before_build
    build
    after_build
fi
