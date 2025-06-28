source libs/common.sh

before_build(){
    echo "开始构建"
}

build(){

    #cd keycloak/docs/documentation
    ./mvnw clean install -am -pl docs/documentation/dist -Pdocumentation
    ls -lha docs/documentation/dist

}

save_return(){
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="kyverno.tgz"

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
if cat .git/config  |grep '/keycloak/keycloak.git' ;then
    echo "匹配到 kyverno"
    before_build
    build
    #after_build
fi
