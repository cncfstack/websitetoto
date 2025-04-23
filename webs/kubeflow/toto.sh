source libs/common.sh

before_build(){
    install_hugo_v124_1
    npm install 
    git submodule update --init --recursive
    cd themes/docsy/ && npm install && cd -

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="bb40c254-9dfe-47ec-9935-ecfd7263cc97"></script>' >>  ./layouts/partials/favicons.html

}

build(){

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://kubeflow.website.cncfstack.com

}

save_return(){
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="kubeflow.tgz"

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
if cat .git/config  |grep '/kubeflow/website.git' ;then
    echo "匹配到 kubeflow"
    before_build
    build
    find_and_sed_v2 "./output"
    save_return 
fi
