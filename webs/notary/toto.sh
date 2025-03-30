workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_notary_website(){
    install_hugo_v83_1
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="e2245cb1-9c47-4c63-9330-88f7e729f480"></script>' >>  ./layouts/partials/favicons.html

}

after_notary_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://notary.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-notary" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/notaryproject/notaryproject.dev.git' ;then
    echo "=============================================> 匹配到 notary"
    before_notary_website
    after_notary_website
    find_and_sed_v2 "./output"
    save_return 
fi
