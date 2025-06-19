source libs/common.sh

before_build(){

    yarn install
    
    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'88e3efe4-27da-45c2-8de3-ee4b9670e39f'}}]})}),|g" docusaurus.config.js
    
    sed -i "s|https://podman.io|https://podman.website.cncfstack.com|g" docusaurus.config.js

    cat ./docusaurus.config.js
}




build(){
    
    log_info "build Podman"

    yarn build

    ls -lh
}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="podman.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C build .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./build"
    save_return
}


cd project_dir
if cat .git/config  |grep '/containers/podman.io.git' ;then
    echo "匹配到 podman"
    before_build
    build
    after_build 
fi
