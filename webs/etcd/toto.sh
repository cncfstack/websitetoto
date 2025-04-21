workdir=$1
initdir=$2

source libs/common.sh

before_etcd_website(){
    install_hugo_v145
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="fd31286b-b455-4b8c-8d83-549b2ab02cff"></script>' >>  layouts/partials/favicons.html

}

after_etcd_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://etcd.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-etcd" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/etcd-io/website.git' ;then
    echo "=============================================> 匹配到 etcd"
    before_etcd_website
    after_etcd_website
    find_and_sed_v2 "./output"
    save_return 
fi
