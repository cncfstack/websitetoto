workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_kyverno_website(){
    install_hugo_v114
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="9e595152-e500-4016-a1d1-a0f2d6b94415"></script>' >>  ./layouts/partials/hooks/head-end.html

}

after_kyverno_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://kyverno.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-kyverno" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/kyverno/website.git' ;then
    echo "=============================================> 匹配到 kyverno"
    before_kyverno_website
    after_kyverno_website
    find_and_sed_v2 "./output"
    save_return 
fi
