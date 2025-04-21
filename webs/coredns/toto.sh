workdir=$1
initdir=$2

source libs/common.sh

before_coredns_website(){
    install_hugo_v100_2
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="9f78fcf9-90dc-4597-8fb8-a2b26aaf7656"></script>' >>  layouts/partials/favicons.html

}

after_coredns_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://coredns.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-coredns" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/coredns/coredns.io.git' ;then
    echo "=============================================> 匹配到 coredns"
    before_coredns_website
    after_coredns_website
    find_and_sed_v2 "./output"
    save_return 
fi
