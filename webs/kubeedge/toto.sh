workdir=$1
initdir=$2

source libs/common.sh


before_kubeedge(){
    npm install
    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'9e00beea-6f49-4460-b456-b4fc5fb216c5'}}]})}),|g" docusaurus.config.js
    cat ./docusaurus.config.js
}

after_kubeedge(){
    echo "npm build-----"

    npm run build

    ls -lh

}


save_return(){
    echo "${workdir}/build&oss://cncfstack-kubeedge" > ${workdir}/ret-data
}


cd $workdir

if cat .git/config  |grep '/kubeedge/website.git' ;then
    echo "=============================================> 匹配到 kubeedge"
    before_kubeedge
    find_and_sed
    after_kubeedge
    save_return 
fi
