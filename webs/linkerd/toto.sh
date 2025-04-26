source libs/common.sh

before_build(){

    install_hugo_v136_5
    install_postcss

    # 添加网站访问统计
    sed -i 's|<head>|<head><script defer src="https://umami.cncfstack.com/script.js" data-website-id="ca77e090-43b0-494c-908a-f0183f0adb53"></script>|g' layouts/_default/baseof.html

}

build(){

    # mkdir output
    # hugo \
    # --environment production \
    # --destination ./output \
    # --cleanDestinationDir \
    # --minify \
    # --gc \
    # --enableGitInfo \
    # --baseURL https://linkerd.website.cncfstack.com
    
    make production-build

}

save_return(){
    ls -lha
    pwd
    echo "${workdir}/output&oss://cncfstack-istio" > ${workdir}/ret-data

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="kyverno.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C public .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./public"
    save_return
}


cd project_dir
if cat .git/config  |grep '/linkerd/website.git' ;then
    echo "匹配到 istio"
    before_build
    build
    after_build
fi