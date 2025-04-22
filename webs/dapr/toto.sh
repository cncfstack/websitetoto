workdir=$1

source libs/common.sh

before_build(){
    install_hugo_v102_3
    #install_postcss

    cd daprdocs
    git submodule update --init --recursive
    sudo npm install -D --save autoprefixer
    sudo npm install -D --save postcss-cli


    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="f376f6f7-74a6-41b4-9455-d7722b3f4af5"></script>' >>  ./layouts/partials/hooks/head-end.html


}

build(){

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://dapr.website.cncfstack.com

}

save_return(){

    #echo "${workdir}/daprdocs/output&oss://cncfstack-dapr" > ${workdir}/ret-data
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="dapr.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C ${workdir}/daprdocs/output .

    if [ ! -s ${tarfile} ];then
        log_error "Loggie 站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    # 注意这里，由于在before_build中进入了 daprdocs 目录了
    echo "${workdir}/daprdocs/${tarfile}" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/dapr/docs.git' ;then
    echo "=============================================> 匹配到 dapr"
    before_build
    build
    find_and_sed_v2 "./output"
    save_return 
fi
