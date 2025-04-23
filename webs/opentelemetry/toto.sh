source libs/common.sh


before_build(){

    install_hugo
    install_postcss

    sudo cp -f hugo /usr/bin/

    #npm run all
    npm run get:submodule
    
    # 先整理依赖和依赖软件的安装
    npm run prepare

    npm run prebuild:production


    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="6bb82b93-9fe4-495a-b2e2-64d8de75d0b3"></script>' >>   layouts/partials/favicons.html

}


build(){

    echo " 构建静态资源"
    npm run build:production

}


save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="opentelemetry.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C public .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}


cd project_dir
if cat .git/config  |grep '/open-telemetry/opentelemetry.io.git' ;then
    echo " 匹配到 opentelemetry"
    before_build
    find_and_sed
    build
    save_return 
fi
