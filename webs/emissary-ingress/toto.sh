workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_emissary-ingress_website(){
    install_hugo_v145

    npm install
    npm run prepare

    ls -lha
    echo "------------------"
    ls -lhathemes/docsy/
    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="f376f6f7-74a6-41b4-9455-d7722b3f4af5"></script>' >>  ./themes/docsy/layouts/partials/favicons.html

}

after_emissary-ingress_website(){

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://emissary-ingress.cncfstack.com

}

save_return(){
    ls -lha
    pwd
    echo "${workdir}/output&oss://cncfstack-emissary-ingress" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/emissary-ingress/emissary-ingress.dev.git' ;then
    echo "=============================================> 匹配到 emissary-ingress"
    before_emissary-ingress_website
    after_emissary-ingress_website
    find_and_sed_v2 "./output"
    save_return 
fi
