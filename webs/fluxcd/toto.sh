workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_flux_website(){
    install_hugo_v122
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

    mkdir output
    sed -i 's|--baseURL $(URL) \|--baseURL https://flux.cncfstack.com --destination ./output \ |g' Makefile
    sed -i 's|PATH=$(BIN_DIR):$(PATH) BRANCH=$(BRANCH) hack/import-flux2-assets.sh|GITHUB_USER=cncfstack GITHUB_TOKEN=${{secret.CNCFSTACK_GITHUB_TOKEN}} PATH=$(BIN_DIR):$(PATH) BRANCH=$(BRANCH) hack/import-flux2-assets.sh|g' Makefile
    cat Makefile

    make yq
    make prereqs
    make gen-content
    make production-build

}

save_return(){
    ls -lha
    echo "${workdir}/app&oss://cncfstack-flux" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/fluxcd/website.git' ;then
    echo "=============================================> 匹配到 flux"
    before_flux_website
    after_flux_website
    find_and_sed_v2 "app"
    save_return 
fi
