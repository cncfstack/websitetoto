workdir=$1
initdir=$2

source libs/common.sh


before_opentelemetry(){

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


after_opentelemetry(){

    echo "=============================================> 构建静态资源"
    npm run build:production

}


save_return(){
    echo "${workdir}/public&oss://cncfstack-opentelemetry" > ${workdir}/ret-data
}


cd $workdir


if cat .git/config  |grep '/open-telemetry/opentelemetry.io.git' ;then
    echo "=============================================> 匹配到 opentelemetry"
    before_opentelemetry
    find_and_sed
    after_opentelemetry
    save_return 
fi
