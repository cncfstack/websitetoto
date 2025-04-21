workdir=$1
initdir=$2

source libs/common.sh

before_istio_website(){

    install_hugo_v136_5
    install_postcss


    # 添加网站访问统计

    sed -i 's|<head>|<head><script defer src="https://umami.cncfstack.com/script.js" data-website-id="ca77e090-43b0-494c-908a-f0183f0adb53"></script>|g' layouts/_default/baseof.html

}

after_istio_website(){

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://istio.cncfstack.com

}

save_return(){
    ls -lha
    pwd
    echo "${workdir}/output&oss://cncfstack-istio" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/istio/istio.io.git' ;then
    echo "=============================================> 匹配到 istio"
    before_istio_website
    after_istio_website
    find_and_sed_v2 "./output"
    save_return 
fi
