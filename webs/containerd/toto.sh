workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_containerd_website(){
    install_hugo_v111_3

    install_postcss
    npm install .


    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="a93d1af2-4dc1-4b93-b844-141af6812cf5"></script>' >>  ./themes/containerd/layouts/partials/meta.html

}

after_containerd_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://containerd.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-containerd" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/containerd/containerd.io.git' ;then
    echo "=============================================> 匹配到 containerd"
    before_containerd_website
    after_containerd_website
    find_and_sed_v2 "./output"
    save_return 
fi
