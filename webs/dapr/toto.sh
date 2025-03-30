workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_dapr_website(){
    install_hugo_v102_3
    #install_postcss


    cd daprdocs
    git submodule update --init --recursive
    sudo npm install -D --save autoprefixer
    sudo npm install -D --save postcss-cli


    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="f376f6f7-74a6-41b4-9455-d7722b3f4af5"></script>' >>  ./layouts/partials/hooks/head-end.html

}

after_dapr_website(){

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://dapr.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-dapr" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/dapr/dapr.io.git' ;then
    echo "=============================================> 匹配到 dapr"
    before_dapr_website
    after_dapr_website
    find_and_sed_v2 "./output"
    save_return 
fi
