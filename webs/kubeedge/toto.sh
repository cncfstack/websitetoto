source libs/common.sh

before_build(){
    npm install
    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'9e00beea-6f49-4460-b456-b4fc5fb216c5'}}]})}),|g" docusaurus.config.js
    cat ./docusaurus.config.js
}

build(){
    echo "npm build-----"

    npm run build

    ls -lh

}


save_return(){
    # echo "${workdir}/build&oss://cncfstack-kubeedge" > ${workdir}/ret-data
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="kubeedge.tgz"

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
if cat .git/config  |grep '/kubeedge/website.git' ;then
    echo " 匹配到 kubeedge"
    before_build
    find_and_sed_v2 "./build"
    build
    save_return 
fi
