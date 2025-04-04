workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_harbor_website(){

    make prepare
    npm i

    install_hugo_v74
    #install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="d2323b72-657c-4da2-9371-67f8383fc2c8"></script>' >>  layouts/partials/favicon.html

}

after_harbor_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
	--buildDrafts \
	--buildFuture \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://harbor.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-harbor" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/goharbor/website.git' ;then
    echo "=============================================> 匹配到 harbor"
    before_harbor_website
    after_harbor_website
    find_and_sed_v2 "./output"
    save_return 
fi
