source libs/common.sh

before_build(){
    echo "开始构建"
}

build(){

    log_info "构建 Docs 模块"
    ./mvnw clean install -am -pl docs/documentation/dist -Pdocumentation,guides
    ls -lha docs/documentation/dist/target
    # #    keycloak-documentation-999.0.0-SNAPSHOT.zip
    # cd docs/documentation/dist/target && unzip keycloak-documentation-*.zip && cd -


    # log_info "构建 Guides 模块"
    # cd docs
    # mvn clean install


    # ./mvnw install -Dtest=!ExternalLinksTest -am -pl docs/documentation/tests,docs/documentation/dist -e -Pdocumentation

    # ./mvnw clean install -Pdocs

    ls -lha

    echo "-----"

    ls -lha target


    echo "=============================================================================="
    ls -lha dist

    echo "=============================================================================="

    ls -lha dist/target
}

save_return(){
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="keycloak.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C docs/documentation/dist/target/keycloak-documentation-* .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./docs/documentation/dist/target"
    save_return
}

cd project_dir
if cat .git/config  |grep '/keycloak/keycloak.git' ;then
    echo "匹配到 keycloak"
    before_build
    build
    #after_build
fi
