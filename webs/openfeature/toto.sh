workdir=$1
initdir=$2

set -x

source libs/common.sh


before_openfeature(){
    
    git submodule update --init --recursive
    yarn install
    
    log_info "=============================================> 配置文件 docusaurus.config.ts 添加 umami"
    #sed -ri "s|themeConfig:\s*\{|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'e560133a-5a27-40ad-b816-9896199ffb01'}}]})})],themeConfig: {|g" docusaurus.config.js

    sed -ri "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'2ef83157-07a7-4bff-a911-e05f83e8663b'}}]})}),|g" docusaurus.config.ts


    log_info "=============================================> ./docusaurus.config.ts 配置文件内容"
    cat ./docusaurus.config.ts


}

after_openfeature(){

    log_info "=============================================> 开始 npm run build 构建"
    yarn run build

    

    log_info "=============================================> 当前目录中文件列表"
    ls -lh

}


save_return(){
    echo "${workdir}/build&oss://cncfstack-openfeature" > ${workdir}/ret-data
}

cd $workdir

if cat .git/config  |grep '/open-feature/openfeature.dev.git' ;then
    log_info "=============================================> 匹配到 open-feature"
    before_openfeature
    find_and_sed_v2 "./build"
    after_openfeature
    save_return 
fi
