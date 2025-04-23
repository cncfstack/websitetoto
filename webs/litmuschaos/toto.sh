source libs/common.sh

before_litmuschaos(){
    
    cd website
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
    
    log_info "配置文件中没有plugins的配置，单独添加，选择一个常用的KEY"
    sed -ri "s|themeConfig:\s*\{|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'494eb503-996b-4489-a5a6-66c557d98c65'}}]})})],themeConfig: {|g" docusaurus.config.js
    
    log_info "./docusaurus.config.js 配置文件内容"
    cat ./docusaurus.config.js

}

after_litmuschaos(){

    log_info "开始 npm run build 构建"
    npm run build

    log_info "当前目录中文件列表"
    ls -lh

}


save_return(){
    #echo "project_dir/website/build&oss://cncfstack-litmuschaos" > project_dir/ret-data

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="litmuschaos.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C build .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/website/${tarfile}" > ret-data
}

cd project_dir

if cat .git/config  |grep '/litmuschaos/litmus-docs.git' ;then
    log_info "匹配到 litmuschaos"
    before_litmuschaos
    find_and_sed_v2 "./website"
    after_litmuschaos
    save_return 
fi
