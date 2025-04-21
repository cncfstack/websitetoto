workdir=$1
initdir=$2

set -x

source libs/common.sh


before_wasmcloud(){
    
    npm install

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
    
    log_info "=============================================> 配置文件中没有plugins的配置，单独添加，选择一个常用的KEY"
    sed -ri "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'ea898aeb-199d-4330-bf53-2e40427bb23d'}}]})}),|g" docusaurus.config.ts
    
    log_info "=============================================> ./docusaurus.config.ts 配置文件内容"
    cat ./docusaurus.config.ts

}

after_wasmcloud(){

    log_info "=============================================> 开始 npm run build 构建"
    npm run build

    log_info "=============================================> 当前目录中文件列表"
    ls -lh

}


save_return(){
    echo "${workdir}/build&oss://cncfstack-wasmcloud" > ${workdir}/ret-data
}

cd $workdir

if cat .git/config  |grep '/wasmCloud/wasmcloud.com.git' ;then
    log_info "=============================================> 匹配到 wasmcloud"
    before_wasmcloud
    after_wasmcloud
    find_and_sed_v2 "./build"
    save_return 
fi
