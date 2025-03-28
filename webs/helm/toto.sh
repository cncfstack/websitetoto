
workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_helm_website(){
    echo "install hugo"
    install_hugo

    # 安装 postCSS
    echo "install postCSS"
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="78a80c38-ac4e-4954-a169-909f40f35336"></script>' >>  themes/helm/layouts/partials/meta.html

}

after_helm_website(){

    # 构建
    ./hugo \
    --cleanDestinationDir \
    --buildFuture \
    --noBuildLock \
    --minify \
    --printI18nWarnings \
    --printMemoryUsage \
    --printPathWarnings \
    --printUnusedTemplates \
    --templateMetrics  \
    --templateMetricsHints \
    --baseURL https://helm.cncfstack.com
}

save_return(){
    echo "复制文件到OSS $workdir $initdir"
    touch ${workdir}/ret-data
    echo "${workdir}/app&oss://cncfstack-test" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/helm/helm-www.git' ;then
    echo "helmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"
    before_helm_website
    find_and_sed
    after_helm_website
    save_return 
fi
