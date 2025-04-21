workdir=$1
initdir=$2

source libs/common.sh



before_vitess(){

    npm install
    install_hugo_v120

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="de57cc57-0486-41d4-b717-09fec9182af6"></script>' >> layouts/partials/meta.html

}

after_vitess(){
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
    --baseURL https://vitess.cncfstack.com

}



save_return(){
    echo "${workdir}/website-site&oss://cncfstack-vitess" > ${workdir}/ret-data
}


cd $workdir

if cat .git/config  |grep '/vitessio/website.git' ;then
    echo "=============================================> 匹配到 vitessio"
    before_vitess
    find_and_sed
    after_vitess
    save_return 
fi

