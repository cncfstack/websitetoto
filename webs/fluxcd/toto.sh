workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_flux_website(){
    echo "install hugo"
    install_hugo

    # 安装 postCSS
    echo "install postCSS"
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="2c71e449-5854-42ad-832f-217add76fc32"></script>' >>  layouts/partials/favicons.html

}

after_flux_website(){


    # ./hugo \
    # --destination ./output \
    # --minify \
    # --gc \
    # --enableGitInfo \
    # --baseURL https://flux.cncfstack.com

    sed -i 's|--baseURL $(URL)|--baseURL https://flux.cncfstack.com|g' Makefile
    make production-build

}

save_return(){
    echo "${workdir}/output&oss://cncfstack-flux" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/fluxcd/website.git' ;then
    echo "=============================================> 匹配到 flux"
    before_flux_website
    find_and_sed
    after_flux_website
    save_return 
fi
