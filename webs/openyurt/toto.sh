source libs/common.sh

before_build(){
    npm install
    
    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'bf711965-231e-4ff8-9620-75f4b7a6256e'}}]})}),|g" docusaurus.config.js
    
    sed -i "s|url:\s\"https://openyurt.io\",|url: 'https://openyurt.website.cncfstack.com',|g" docusaurus.config.js

    cat ./docusaurus.config.js
}

build(){
    echo "npm build-----"

    npm run build

    ls -lh
}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="openyurt.tgz"

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
if cat .git/config  |grep '/openyurtio/openyurt.io.git' ;then
    echo "匹配到 openyurt"
    before_build
    build
    after_build 
fi
