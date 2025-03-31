workdir=$1
initdir=$2

set -x

source ${initdir}/libs/common.sh


before_dragonfly(){
    
    yarn install


# [
#     ()=>(
#         {
#             name:'umami-analytics',
#             injectHtmlTags:()=>(
#                 {
#                     headTags:[
#                         {
#                             tagName:'script',
#                             attributes:{
#                                 defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'494eb503-996b-4489-a5a6-66c557d98c65'
#                             }
#                         }
#                     ]
#                 }
#             )
#         }
#     )
# ]
#sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'e560133a-5a27-40ad-b816-9896199ffb01'}}]})}),|g" docusaurus.config.js
    
    log_info "=============================================> 配置文件中添加 umami"
    sed -ri "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'c2f7c701-67da-49ac-9baa-f0daad6b1902'}}]})}),|g" docusaurus.config.js
    
    log_info "=============================================> ./docusaurus.config.js 配置文件内容"
    cat ./docusaurus.config.js

}

after_dragonfly(){

    log_info "=============================================> 开始 build 构建"
    yarn build

    log_info "=============================================> 当前目录中文件列表"
    ls -lh
}


save_return(){
    echo "${workdir}/build&oss://cncfstack-dragonfly" > ${workdir}/ret-data
}

cd $workdir

if cat .git/config  |grep '/dragonflyoss/d7y.io.git' ;then
    log_info "=============================================> 匹配到 dragonfly"
    before_dragonfly
    after_dragonfly
    find_and_sed_v2 "./build"
    save_return 
fi
