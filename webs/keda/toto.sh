workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_keda_website(){
    #"npm run build:production"
    # "0.93.2",
    install_hugo_v93_2
    npm install 


    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="3b2e32f4-448c-4773-a1f1-b40656d8c35d"></script>' >>  ./layouts/partials/favicon.html

}

after_keda_website(){

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://keda.cncfstack.com

}

save_return(){
    ls -lha
    pwd
    echo "${workdir}/output&oss://cncfstack-keda" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/kedacore/keda-docs.git' ;then
    echo "=============================================> 匹配到 keda"
    before_keda_website
    after_keda_website
    find_and_sed_v2 "./output"
    save_return 
fi
