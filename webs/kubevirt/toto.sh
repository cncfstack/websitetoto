source libs/common.sh

# 分析
# KubeVirt 有两个文档项目，一个是网站，一个文档
# 网站：https://github.com/kubevirt/kubevirt.github.io.git
# 文档：https://github.com/kubevirt/user-guide
# 
# 网站的导航中文档地址写死了，需要进行修改： https://github.com/kubevirt/kubevirt.github.io/blob/main/_data/site_nav_pages.yml



before_build(){
    log_info "添加网站访问统计 "
}

build(){

    git clone -b gh-pages https://github.com/kubevirt/kubevirt.github.io.git ./kubevirt-gh-pages

    git clone -b gh-pages https://github.com/kubevirt/user-guide  ./kubevirt-gh-pages/user-guide
    
}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="kubevirt.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C ./kubevirt-gh-pages .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./kubevirt-gh-pages"
    save_return
}

cd project_dir
if cat .git/config  |grep '/kubevirt/kubevirt.github.io.git' ;then
    echo "匹配到 kubevirt"
    before_build
    build
    after_build
fi
