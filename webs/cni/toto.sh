workdir=$1

source libs/common.sh

before_build(){
    install_hugo_v80
    install_postcss

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="8487f759-4fa6-4d01-9ead-477f675bfaf9"></script>' >>  ./layouts/partials/favicon.html

}

after_cni_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://cni.website.cncfstack.com

}

save_return(){
    ls -lha
    #echo "${workdir}/output&oss://cncfstack-cni" > ${workdir}/ret-data

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="cni.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C output .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    echo "${workdir}/${tarfile}" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/containernetworking/cni.dev.git' ;then
    echo "=============================================> 匹配到 cni"
    before_build
    after_cni_website
    find_and_sed_v2 "./output"
    save_return 
fi
