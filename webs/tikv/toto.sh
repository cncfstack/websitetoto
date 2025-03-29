workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_tikv_website(){
    install_hugo_v66
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="8a09ce9c-6be3-4eea-b945-6927bce5c748"></script>' >>  layouts/partials/meta.html

}

after_tikv_website(){

    mkdir output
    hugo \
    --destination ./output \
    --buildFuture \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://tikv.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-tikv" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/tikv/website.git' ;then
    echo "=============================================> 匹配到 TiKV"
    before_tikv_website
    after_tikv_website
    find_and_sed_v2 "./output"
    save_return 
fi
