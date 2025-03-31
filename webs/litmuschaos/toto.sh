workdir=$1
initdir=$2

set -x

source ${initdir}/libs/common.sh


before_litmuschaos(){
    
    cd website
    npm install

    #sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'e560133a-5a27-40ad-b816-9896199ffb01'}}]})}),|g" docusaurus.config.js
    
    log_info "=============================================> 配置文件中没有plugins的配置，单独添加，选择一个常用的KEY"
    sed -i "s|themeConfig:\s*\{|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'e560133a-5a27-40ad-b816-9896199ffb01'}}]})})],themeConfig: {|g" docusaurus.config.js
    
    log_info "=============================================> ./docusaurus.config.js 配置文件内容"
    cat ./docusaurus.config.js
# plugins: [
#   // ...其他插件...
#   () => ({ 
#     name: 'umami-analytics',
#     injectHtmlTags: () => ({
#       headTags: [{
#         tagName: 'script',
#         attributes: {
#           defer: true,
#           src: 'https://umami.cncfstack.com/script.js',
#           'data-website-id': 'ea260eb5-e4cc-4e4e-ad63-e1b227bd5feb'
#         }
#       }]
#     })
#   }),
# ],
 

}

after_litmuschaos(){

    log_info "=============================================> 开始 npm run build 构建"
    npm run build

    log_info "=============================================> 当前目录中文件列表"
    ls -lh

}


save_return(){
    echo "${workdir}/website/build&oss://cncfstack-litmuschaos" > ${workdir}/ret-data
}

cd $workdir

if cat .git/config  |grep '/litmuschaos/litmus-docs.git' ;then
    log_info "=============================================> 匹配到 chaos-mesh"
    before_litmuschaos
    find_and_sed_v2 "./website"
    after_litmuschaos
    save_return 
fi
