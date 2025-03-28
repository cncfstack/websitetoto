workdir=$1
initdir=$2

source ${initdir}/libs/common.sh



before_vitess(){

    echo "npm install"
    npm install
    
    echo "install hugo"
    install_hugo_v120

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="de57cc57-0486-41d4-b717-09fec9182af6"></script>' >> layouts/partials/meta.html

}

after_vitess(){
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
    --baseURL https://vitess.cncfstack.com

    echo "复制文件到OSS"
    # $OSSUTIL sync app oss://cncfstack-helm --force --update  --job=10 --checkpoint-dir=/tmp/osscheck --exclude=.DS_Store 
    #$OSSUTIL cp -fr website-site oss://cncfstack-vitess
}



save_return(){
    echo "${workdir}/website-site&oss://cncfstack-vitess" > ${workdir}/ret-data
}


cd $workdir

if cat .git/config  |grep '/vitessio/website.git' ;then
    echo "/vitessio/website.git"
    before_vitess
    find_and_sed
    after_vitess
    save_return 
fi

