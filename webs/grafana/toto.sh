source libs/common.sh

before_build(){
    log_info "build grafana"
}


build(){
    
    cd docs
    
    make docs

    ls -lh
}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="grafana.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C build .

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
if cat .git/config  |grep '/grafana/grafana.git' ;then
    echo "匹配到 Grafana"
    before_build
    build
    #after_build 
fi
