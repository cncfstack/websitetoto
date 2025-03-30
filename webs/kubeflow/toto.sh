workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_kubeflow_website(){
    install_hugo_v124_1
    npm install 
    git submodule update --init --recursive
    cd themes/docsy/ && npm install && cd -

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="bb40c254-9dfe-47ec-9935-ecfd7263cc97"></script>' >>  ./layouts/partials/favicons.html

}

after_kubeflow_website(){

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://kubeflow.cncfstack.com

}

save_return(){
    ls -lha
    pwd
    echo "${workdir}/output&oss://cncfstack-kubeflow" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/kubeflow/website.git' ;then
    echo "=============================================> 匹配到 kubeflow"
    before_kubeflow_website
    after_kubeflow_website
    find_and_sed_v2 "./output"
    save_return 
fi
