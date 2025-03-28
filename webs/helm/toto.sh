#!/bin/bash

workdir=$1
initdir=$2

source ${initdir}/libs/common.sh



before_helm_website(){
    # 需要安装 postCSS https://gohugo.io/functions/css/postcss/
    # postCSS 依赖 Nodejs
    # 安装 nodejs
    #ossutil cp oss://cncfstack-cdn/dist/v22.14.0/node-v22.14.0-linux-x64.tar.xz ./
    #tar xf node-v22.14.0-linux-x64.tar.xz
    #mv node-v22.14.0-linux-x64 /opt/
    # echo 'PATH=/opt/node-v22.14.0-linux-x64/bin/:$PATH' >> /etc/profiles
    # source /etc/profiles
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
    $HUGO \
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

    echo "复制文件到OSS"
    $OSSUTIL ls
}


if cat .git/config  |grep '/helm/helm-www.git' ;then
    before_helm_website
    find_and_sed
    after_helm_website
fi
