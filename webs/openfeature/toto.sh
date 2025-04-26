source libs/common.sh

before_build(){
    
    git submodule update --init --recursive
    yarn install
    
    log_info "配置文件 docusaurus.config.ts 添加 umami"
    #sed -ri "s|themeConfig:\s*\{|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'e560133a-5a27-40ad-b816-9896199ffb01'}}]})})],themeConfig: {|g" docusaurus.config.js

    sed -ri "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'2ef83157-07a7-4bff-a911-e05f83e8663b'}}]})}),|g" docusaurus.config.ts

    sed -i "s|url:\s*'https://openfeature.dev',|url: 'https://openfeature.website.cncfstack.com',|g" docusaurus.config.js


    log_info "./docusaurus.config.ts 配置文件内容"
    cat ./docusaurus.config.ts

}

build(){

    log_info "开始 npm run build 构建"
    yarn run build

    
    log_info "当前目录中文件列表"
    ls -lh

}


save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="openfeature.tgz"

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
if cat .git/config  |grep '/open-feature/openfeature.dev.git' ;then
    log_info "匹配到 open-feature"
    before_build
    build
    after_build
fi
