source libs/common.sh

before_build(){
    
    log_info "yarn install 安装依赖"
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
    
    log_info "配置文件中添加 umami"
    sed -ri "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'c2f7c701-67da-49ac-9baa-f0daad6b1902'}}]})}),|g" docusaurus.config.js
    
    # URL 配置影响站点的 sitemap.xml 文件的生成
    sed -i "s|url: 'https://d7y.io',|url: 'https://dragonfly.website.cncfstack.com',|g" docusaurus.config.js

    log_info "./docusaurus.config.js 配置文件内容"
    cat ./docusaurus.config.js

}

build(){

    log_info "开始 build 构建"
    yarn build

    log_info "当前目录中文件列表"
    ls -lh
}


save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="dragonfly.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C build .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    # 注意这里，由于在before_build中进入了 daprdocs 目录了
    echo "project_dir/${tarfile}" > ret-data
}

cd project_dir
if cat .git/config  |grep '/dragonflyoss/d7y.io.git' ;then
    log_info "匹配到 dragonfly"
    before_build
    build
    find_and_sed_v2 "./build"
    save_return 
fi
