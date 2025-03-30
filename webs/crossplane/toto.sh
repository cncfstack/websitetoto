workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_crossplane_website(){
    install_hugo_v145
    npm install 


    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="9b8051a7-fd5d-4cec-b8fe-3e9ec82cfad1"></script>' >>  ./themes/geekboot/layouts/partials/favicons.html

}

after_crossplane_website(){

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://crossplane.cncfstack.com

}

save_return(){
    ls -lha
    pwd
    echo "${workdir}/output&oss://cncfstack-crossplane" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/crossplane/docs.git' ;then
    echo "=============================================> 匹配到 crossplane"
    before_crossplane_website
    after_crossplane_website
    find_and_sed_v2 "./output"
    save_return 
fi
