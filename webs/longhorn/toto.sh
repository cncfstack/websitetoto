workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_longhorn_website(){
    install_hugo_v65_3
    install_postcss
    yarn install

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="a657de2b-4013-421e-b387-fe12fc699024"></script>' >>  ./layouts/partials/favicon.html

}

after_longhorn_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://longhorn.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-longhorn" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/longhorn/website.git' ;then
    echo "=============================================> 匹配到 longhorn"
    before_longhorn_website
    after_longhorn_website
    find_and_sed_v2 "./output"
    save_return 
fi
