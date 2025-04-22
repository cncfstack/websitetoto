source libs/common.sh

before_build(){
    yarn install
    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'8c8b1d6d-a7fa-43ca-9933-db30591777e9'}}]})}),|g" docusaurus.config.js
    cat ./docusaurus.config.js
}

build(){
    echo "npm build-----"

    yarn build

    ls -lh

}


save_return(){
    # echo "${workdir}/build&oss://cncfstack-kubevela" > ${workdir}/ret-data

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="kubevela.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C build .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}


cd project_dir
if cat .git/config  |grep '/kubevela/kubevela.github.io.git' ;then
    echo "匹配到 kubevela"
    before_build
    find_and_sed
    build
    save_return 
fi
