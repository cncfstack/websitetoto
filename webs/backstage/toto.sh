source libs/common.sh

before_build(){

    cd microsite
    yarn install

    # 添加网站访问统计JS
    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'debf0344-1260-4876-a5c7-c1b2b4bd3a10'}}]})}),|g"  docusaurus.config.ts
    
    # URL 配置影响站点的 sitemap.xml 文件的生成
    sed -i "s|url: 'https://backstage.io',|url: 'https://backstage.website.cncfstack.com',|g" docusaurus.config.ts
    
    cat docusaurus.config.ts
}

build(){

    log_info "开始 npm run build 构建"
    yarn build

    log_info "当前目录中文件列表"
    ls -lh

}


save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="backstage.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C build .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"
    echo "project_dir/microsite/${tarfile}" > ../ret-data
}

after_build(){
    filetoto "./build"
    save_return
}

cd project_dir
if cat .git/config  |grep '/backstage/backstage.git' ;then
    log_info "匹配到 backstage"
    before_build
    build
    after_build
fi
