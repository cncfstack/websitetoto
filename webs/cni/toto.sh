workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_cni_website(){
    install_hugo_v80
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="8487f759-4fa6-4d01-9ead-477f675bfaf9"></script>' >>  ./layouts/partials/favicon.html

}

after_cni_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://cni.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-cni" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/containernetworking/cni.dev.git' ;then
    echo "=============================================> 匹配到 cni"
    before_cni_website
    after_cni_website
    find_and_sed_v2 "./output"
    save_return 
fi
