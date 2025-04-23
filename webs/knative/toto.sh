source libs/common.sh

before_build(){

    pip install -r requirements.txt
    bash -x ./hack/build.sh
    
}

build(){

    log_info "当前目录中文件列表"
    ls -lh

    log_info "development"
    ls -lh ./site/development
    log_info "docs"
    ls -lh ./site/docs

}


save_return(){
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="knative.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C site .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

cd project_dir
if cat .git/config  |grep '/knative/docs.git' ;then
    log_info "匹配到 knative"
    before_build
    build
    find_and_sed_v2 "./build"
    save_return 
fi
