workdir=$1
initdir=$2

source ${initdir}/libs/common.sh


before_volcano(){
    echo "npm install"
    npm install
    
    echo "install hugo"
    install_hugo_v120

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="8ccc7a7d-06b8-477d-9d25-eb27c0ac9bbc"></script>' >> layouts/partials/favicons.html

}
after_volcano(){
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
    --baseURL https://volcano.cncfstack.com

    echo "复制文件到OSS"
    #$OSSUTIL cp -fr website-site oss://cncfstack-volcano
}



save_return(){
    echo "${workdir}/website-site&oss://cncfstack-volcano" > ${workdir}/ret-data
}


cd $workdir


if cat .git/config  |grep '/volcano-sh/website.git' ;then
    echo "/volcano-sh/website.git"
    before_volcano
    find_and_sed
    after_volcano
    save_return 
fi
