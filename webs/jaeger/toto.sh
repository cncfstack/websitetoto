set -x

workdir=$1
initdir=$2

source libs/common.sh

before_jaeger_website(){
    install_hugo_v143_1
    install_postcss

    echo "该项目依赖 bluma，需要安装对应版本的依赖"
    cd themes/jaeger-docs && npm install && cd -

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="ad128657-afe1-4074-aa5e-279f72db2a62"></script>' >>  themes/jaeger-docs/layouts/partials/meta.html

}

after_jaeger_website(){

    #command = "make netlify-production-build"

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --ignoreCache \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://jaeger.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-jaeger" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/jaegertracing/documentation.git' ;then
    echo "=============================================> 匹配到 jaeger"
    before_jaeger_website
    after_jaeger_website
    find_and_sed_v2 "./output"
    save_return 
fi
