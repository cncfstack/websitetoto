workdir=$1
initdir=$2

source ${initdir}/libs/common.sh


before_openkruise(){
    npm install
    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'bf711965-231e-4ff8-9620-75f4b7a6256e'}}]})}),|g" docusaurus.config.js
    cat ./docusaurus.config.js
}

after_openkruise(){
    echo "npm build-----"

    npm run build

    ls -lh

    echo "复制文件到OSS"
#    $OSSUTIL cp -fr build oss://cncfstack-openkruise
}



save_return(){
    echo "${workdir}/build&oss://cncfstack-openkruise" > ${workdir}/ret-data
}


cd $workdir

if cat .git/config  |grep '/openkruise/openkruise.io.git' ;then
    echo "/openkruise/openkruise.io.git"
    before_openkruise
    find_and_sed
    after_openkruise
    save_return 
fi
