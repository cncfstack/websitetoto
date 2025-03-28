workdir=$1
initdir=$2

source ${initdir}/libs/common.sh


before_cloudevents(){
    echo "cloudevent"
    echo "install hugo"
    #  Hugo v0.120.0 
    install_hugo_v120

    # 安装 postCSS
    echo "install postCSS"
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="8a773cf4-261d-4258-9adc-c8031b8f69ae"></script>' >>  layouts/partials/javascript.html

}

after_cloudevents(){
    echo "cloudevent"
     # 构建
    mkdir website-site

    $HUGO \
    --destination ./website-site \
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
    --baseURL https://cloudevents.cncfstack.com

    echo "复制文件到OSS"
    # $OSSUTIL sync app oss://cncfstack-helm --force --update  --job=10 --checkpoint-dir=/tmp/osscheck --exclude=.DS_Store 
    #$OSSUTIL cp -fr website-site oss://cncfstack-cloudevents
}


save_return(){
    echo "${workdir}/website-site&oss://cncfstack-cloudevents" > ${workdir}/ret-data
}


cd $workdir


    if cat .git/config  |grep '/cloudevents/cloudevents-web.git' ;then
        echo "/cloudevents/cloudevents-web.git"
        before_cloudevents
        find_and_sed
        after_cloudevents
    save_return 
    fi
