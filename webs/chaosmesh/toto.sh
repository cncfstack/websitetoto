workdir=$1
initdir=$2

source libs/common.sh


before_chaosmesh(){
    
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

after_chaosmesh(){

    echo "开始镜像 npm run build 构建"
    npm run build

    echo "当前目录中文件列表"
    ls -lh

}


save_return(){
    echo "${workdir}/build&oss://cncfstack-chaosmesh" > ${workdir}/ret-data
}

cd $workdir

if cat .git/config  |grep '/chaos-mesh/website.git' ;then
    echo "=============================================> 匹配到 chaos-mesh"
    before_chaosmesh
    find_and_sed
    after_chaosmesh
    save_return 
fi
