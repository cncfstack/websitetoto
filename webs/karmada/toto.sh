workdir=$1
initdir=$2

source ${initdir}/libs/common.sh


before_karmada(){
    npm install
    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'77375498-62d6-417f-ba87-4945bfe9b001'}}]})}),|g" docusaurus.config.js
    cat ./docusaurus.config.js
}
after_karmada(){
     echo "npm build-----"

    npm run build

    ls -lh

    echo "复制文件到OSS"
#    $OSSUTIL cp -fr build oss://cncfstack-karmada
}

save_return(){
    echo "${workdir}/build&oss://cncfstack-karmada" > ${workdir}/ret-data
}



cd $workdir

if cat .git/config  |grep '/karmada-io/website.git' ;then
    echo "/karmada-io/website.git"
    before_karmada
    find_and_sed
    after_karmada
    save_return 
fi
