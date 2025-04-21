workdir=$1
initdir=$2

source libs/common.sh


before_openyurt(){
    npm install
    sed -i "s|plugins:\s*\[|plugins: [()=>({name:'umami-analytics',injectHtmlTags:()=>({headTags:[{tagName:'script',attributes:{defer:true,src:'https://umami.cncfstack.com/script.js','data-website-id':'bf711965-231e-4ff8-9620-75f4b7a6256e'}}]})}),|g" docusaurus.config.js
    cat ./docusaurus.config.js
}

after_openyurt(){
    echo "npm build-----"

    npm run build

    ls -lh
}

save_return(){
    echo "${workdir}/build&oss://cncfstack-openyurt" > ${workdir}/ret-data
}

cd $workdir

if cat .git/config  |grep '/openyurtio/openyurt.io.git' ;then
    echo "=============================================> 匹配到 openyurt"
    before_openyurt
    find_and_sed
    after_openyurt
    save_return 
fi
