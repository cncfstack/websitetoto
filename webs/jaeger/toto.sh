source libs/common.sh

before_build(){
    install_hugo_v143_1
    install_postcss

    log_info "该项目依赖 bluma，需要安装对应版本的依赖"
    cd themes/jaeger-docs && npm install && cd -

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="ad128657-afe1-4074-aa5e-279f72db2a62"></script>' >>  themes/jaeger-docs/layouts/partials/meta.html

}

build(){

    #command = "make netlify-production-build"

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --ignoreCache \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://jaeger.website.cncfstack.com

}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="jaeger.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C output .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    # Jaeger在构建完成后，并不能生成sass的css文件，页面局部强依赖，所以从原来的官网进行同步
    # 但是，这个文件可能会变化，需要定期关注
    curl  -fsSL   https://www.jaegertracing.io/css/style.ef9a0a808867e6c9162c0e279c43705ccc7a3a3bac3db8b6796c4e609335c848.css -o ./output/css/style.ef9a0a808867e6c9162c0e279c43705ccc7a3a3bac3db8b6796c4e609335c848.css

    mkdir output/sass
    curl  -fsSL   https://www.jaegertracing.io/css/style.ef9a0a808867e6c9162c0e279c43705ccc7a3a3bac3db8b6796c4e609335c848.css -o ./output/sass/style.sass
}


cd project_dir
if cat .git/config  |grep '/jaegertracing/documentation.git' ;then
    echo "匹配到 jaeger"
    before_build
    build
    after_build
    cycle_sed "./output"
    save_return 
fi
