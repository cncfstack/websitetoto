workdir=$1

source libs/common.sh

before_build(){
    install_hugo_v111_3

    install_postcss
    npm install .


    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="a93d1af2-4dc1-4b93-b844-141af6812cf5"></script>' >>  ./themes/containerd/layouts/partials/meta.html

}

after_containerd_website(){

    #npm run build:production

    mkdir output
    hugo \
    --destination ./output \
    --cleanDestinationDir \
    --minify \
    --gc \
    --enableGitInfo \
    --baseURL https://containerd.website.cncfstack.com

}

save_return(){
    ls -lha
    #echo "${workdir}/output&oss://cncfstack-containerd" > ${workdir}/ret-data

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="containerd.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C output .

    if [ ! -s ${tarfile} ];then
        log_error "Loggie 站点构建失败"
    fi

    echo "${workdir}/${tarfile}" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/containerd/containerd.io.git' ;then
    echo "=============================================> 匹配到 containerd"
    before_build
    after_containerd_website
    find_and_sed_v2 "./output"
    save_return 
fi
