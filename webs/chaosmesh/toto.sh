source libs/common.sh

before_build(){
    
    npm install

    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'e560133a-5a27-40ad-b816-9896199ffb01'}}]})}),|g" docusaurus.config.js
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

build(){

    logo_info "开始镜像 npm run build 构建"
    npm run build

    log_info "当前目录中文件列表"
    ls -lh

}


save_return(){
    #echo "${workdir}/build&oss://cncfstack-chaosmesh" > ${workdir}/ret-data
        
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="chaosmesh.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C build .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

cd project_dir
if cat .git/config  |grep '/chaos-mesh/website.git' ;then
    echo "匹配到 chaos-mesh"
    before_build
    find_and_sed_v2 build
    build
    save_return 
fi
