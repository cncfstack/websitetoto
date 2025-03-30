workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_in-toto_website(){
    install_hugo_v139_3
    install_postcss
    npm install
    npm run prepare
    

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="4efc5a30-2d38-479a-ba78-6c5fe9b4b2a1"></script>' >>  layouts/partials/favicons.html

}

after_in-toto_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://in-toto.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-in-toto" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/in-toto/in-toto.io.git' ;then
    echo "=============================================> 匹配到 in-toto"
    before_in-toto_website
    after_in-toto_website
    find_and_sed_v2 "./output"
    save_return 
fi
