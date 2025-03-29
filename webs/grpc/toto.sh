set -x

workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_grpc_website(){
    install_hugo_v99_1
    install_postcss




    echo "该项目依赖 bluma，需要安装对应版本的依赖"
    cd themes/grpc-docs && npm install && cd -

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="553c6a72-641e-4b7c-9d82-d0bfaf213c0a"></script>' >>  layouts/partials/meta.html

}

after_grpc_website(){

    #command = "npm run build:production"

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --ignoreCache \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://grpc.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-grpc" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/grpc/grpc.io.git' ;then
    echo "=============================================> 匹配到 grpc"
    before_grpc_website
    after_grpc_website
    find_and_sed_v2 "./output"
    save_return 
fi
