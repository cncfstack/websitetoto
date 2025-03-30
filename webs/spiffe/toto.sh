workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_spiffe_website(){

    install_hugo_v68_3
    npm install
    python pull_external.py

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="86f12ca0-83a8-470a-af6c-6ba96d72998e"></script>' >>  layouts/partials/meta.html

}

after_spiffe_website(){

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
    --baseURL https://spiffe.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-spiffe" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/spiffe/spiffe.io.git' ;then
    echo "=============================================> 匹配到 spiffe"
    before_spiffe_website
    after_spiffe_website
    find_and_sed_v2 "./output"
    save_return 
fi
