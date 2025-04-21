workdir=$1
initdir=$2

source libs/common.sh

before_falco_website(){
    install_hugo_v108
    install_postcss
    make dependencies

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="8e3dd142-ae95-4964-a6b9-1bff4c3dffcf"></script>' >>  layouts/partials/hooks/head-end.html

}

after_falco_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://falco.cncfstack.com

}

save_return(){
    ls -lha
    echo "${workdir}/output&oss://cncfstack-falco" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/falcosecurity/falco-website.git' ;then
    echo "=============================================> 匹配到 falco"
    before_falco_website
    after_falco_website
    find_and_sed_v2 "./output"
    save_return 
fi
