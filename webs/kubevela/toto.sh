workdir=$1
initdir=$2

source ${initdir}/libs/common.sh



before_kubevela(){
    npm install
    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'8c8b1d6d-a7fa-43ca-9933-db30591777e9'}}]})}),|g" docusaurus.config.js
    cat ./docusaurus.config.js
}

after_kubevela(){
    echo "npm build-----"

    npm run build

    ls -lh

    echo "复制文件到OSS"
#    $OSSUTIL cp -fr build oss://cncfstack-kubevela 
}



save_return(){
    echo "${workdir}/build&oss://cncfstack-kubevela" > ${workdir}/ret-data
}


cd $workdir


if cat .git/config  |grep '/kubevela/kubevela.github.io.git' ;then
    echo "/kubevela/kubevela.github.io.git"
    before_kubevela
    find_and_sed
    after_kubevela
    save_return 
fi
