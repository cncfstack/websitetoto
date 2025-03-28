workdir=$1
initdir=$2

source ${initdir}/libs/common.sh


before_opentelemetry(){

    echo "/open-telemetry/opentelemetry.io.git"
    # 可能是bug，而且应该是在替换前获取该模块

    echo "install hugo"
    install_hugo

    # 安装 postCSS
    echo "install postCSS"
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

    echo "/open-telemetry/opentelemetry.io.git"
    # 可能是bug，而且应该是在替换前获取该模块

    # 先执行获取依赖
    npm run build:production

    $OSSUTIL sync public oss://cncfstack-opentelemetry --force --update  --job=10 --checkpoint-dir=/tmp/osscheck --exclude=.DS_Store 

}


save_return(){
    echo "${workdir}/app&oss://cncfstack-opentelemetry" > ${workdir}/ret-data
}


cd $workdir

if cat .git/config  |grep '/open-telemetry/opentelemetry.io.git' ;then
   before_opentelemetry
   find_and_sed
   after_opentelemetry
   save_return 
fi
