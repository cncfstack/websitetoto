workdir=$1
initdir=$2

source libs/common.sh


before_openkruise(){
    npm install
    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'66308564-be18-4fbd-9e48-9de74708242d'}}]})}),|g" docusaurus.config.js
    cat ./docusaurus.config.js
}

after_openkruise(){
    echo "npm build-----"

    npm run build

    ls -lh
}



save_return(){
    echo "${workdir}/build&oss://cncfstack-openkruise" > ${workdir}/ret-data
}


cd $workdir

if cat .git/config  |grep '/openkruise/openkruise.io.git' ;then
    echo "=============================================> 匹配到 openkruise"
    before_openkruise
    find_and_sed
    after_openkruise
    save_return 
fi
