source libs/common.sh

before_build(){
    #"npm run build:production"
    # "0.93.2",
    install_hugo_v93_2
    npm install 


    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="3b2e32f4-448c-4773-a1f1-b40656d8c35d"></script>' >>  ./layouts/partials/favicon.html

}

build(){

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://keda.website.cncfstack.com

}

save_return(){
    # ls -lha
    # pwd
    # echo "${workdir}/output&oss://cncfstack-keda" > ${workdir}/ret-data

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="keda.tgz"

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
if cat .git/config  |grep '/kedacore/keda-docs.git' ;then
    echo "匹配到 keda"
    before_build
    build
    find_and_sed_v2 "./output"
    save_return 
fi
