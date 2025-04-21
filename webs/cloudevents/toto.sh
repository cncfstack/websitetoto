workdir=$1
initdir=$2

source libs/common.sh


before_cloudevents(){
 
    install_hugo_v120
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="8a773cf4-261d-4258-9adc-c8031b8f69ae"></script>' >>  layouts/partials/javascript.html

}

after_cloudevents(){
    echo "cloudevent"
     # 构建
    mkdir website-site

    ./hugo \
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
}


save_return(){
    echo "${workdir}/website-site&oss://cncfstack-cloudevents" > ${workdir}/ret-data
}


cd $workdir

if cat .git/config  |grep '/cloudevents/cloudevents-web.git' ;then
    echo "=============================================> 匹配到 cloudevents"
    before_cloudevents
    find_and_sed
    after_cloudevents
    save_return 
fi