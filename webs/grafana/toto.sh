source libs/common.sh

before_build(){
    log_info "build grafana"
    # 当前在 project_dir 目录下,../是工作目录，不是项目目录了
    # 重新拉取grafana项目，保证路径位 workdir/grafana/.git/config
    cd .. && git clone https://github.com/grafana/grafana.git
    # 然后进入grafana项目
    cd grafana
    pwd
}


build(){
    
    cd docs

    make docs-local-static
    pwd
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
