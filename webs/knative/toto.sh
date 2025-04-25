source libs/common.sh

before_build(){

    pip install -r requirements.txt

    sed -i "s|site_url: https://knative.dev/docs|site_url: https://knative.website.cncfstack.com/docs|g" mkdocs.yml

    cat mkdocs.yml
}

build(){

    BUILD_VERSIONS="no"
    export BUILD_VERSIONS="no"

    # 构建脚本
    bash -x ./hack/build.sh

    log_info "当前目录中文件列表"
    ls -lh

    log_info "./site/development 目录中文件"
    ls -lh ./site/development
    log_info "./site/docs 目录中的文件"
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


after_build(){
    filetoto "./build"
    save_return
}


cd project_dir
if cat .git/config  |grep '/knative/docs.git' ;then
    log_info "匹配到 knative"
    before_build
    build
    after_build
fi
