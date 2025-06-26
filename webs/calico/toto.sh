source libs/common.sh

before_build(){
    
    log_info "Calico 的 make build 前 init 会自动安装依赖"
    # yarn install

    log_info "配置文件中添加 Calico umami"
    sed -ri "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'bdb7bef3-9b2b-41b0-878d-0f0ac2e1afd7'}}]})}),|g" docusaurus.config.js
    
    # URL 配置影响站点的 sitemap.xml 文件的生成
    sed -i "s|url: 'https://docs.tigera.io',|url: 'https://calico.website.cncfstack.com',|g" docusaurus.config.js

    log_info "./docusaurus.config.js 配置文件内容"
    cat ./docusaurus.config.js

}

build(){

    log_info "开始 build 构建"
    make build

    log_info "当前目录中文件列表"
    ls -lh
}


save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="calico.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C build .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    # 注意这里，由于在before_build中进入了 daprdocs 目录了
    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./build"
    save_return
}

cd project_dir
if cat .git/config  |grep '/tigera/docs.git' ;then
    log_info "匹配到 calico"
    before_build
    build
    after_build
fi
