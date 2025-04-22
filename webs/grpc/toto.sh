source libs/common.sh

before_build(){
    install_hugo_v99_1
    install_postcss

    #To build and serve the site, you'll need the latest LTS release of Node. Install it using nvm, for example:
    nvm install --lts
    npm install 

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="553c6a72-641e-4b7c-9d82-d0bfaf213c0a"></script>' >>  layouts/partials/meta.html

}

build(){

    #command = "npm run build:production"

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --ignoreCache \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://grpc.website.cncfstack.com

}

save_return(){
    # ls -lha
    # echo "${workdir}/output&oss://cncfstack-grpc" > ${workdir}/ret-data

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="grpc.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C output .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}


cd project_dir
if cat .git/config  |grep '/grpc/grpc.io.git' ;then
    echo "=============================================> 匹配到 grpc"
    before_build
    build
    find_and_sed_v2 "./output"
    save_return 
fi
