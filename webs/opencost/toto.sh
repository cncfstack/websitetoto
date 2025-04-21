workdir=$1
initdir=$2

set -x

source libs/common.sh


before_opencost(){
    
    npm install
    
    log_info "=============================================> 配置文件中没有plugins的配置，单独添加，选择一个常用的KEY"
    #sed -i "s|themeConfig:\s*\{|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'e560133a-5a27-40ad-b816-9896199ffb01'}}]})})],themeConfig: {|g" docusaurus.config.js

    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'7ca83057-271c-475a-b048-768e444e0076'}}]})}),|g" docusaurus.config.js

    log_info "=============================================> ./docusaurus.config.js 配置文件内容"
    cat ./docusaurus.config.js


}

after_opencost(){

    log_info "=============================================> 开始 npm run build 构建"
    npm run build

    log_info "=============================================> 当前目录中文件列表"
    ls -lh

}


save_return(){
    echo "${workdir}/build&oss://cncfstack-opencost" > ${workdir}/ret-data
}

cd $workdir

if cat .git/config  |grep '/opencost/opencost-website.git' ;then
    log_info "=============================================> 匹配到 chaos-mesh"
    before_opencost
    find_and_sed_v2 "./build"
    after_opencost
    save_return 
fi
