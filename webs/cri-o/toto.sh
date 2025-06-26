source libs/common.sh

before_build(){

    log_info "开始构建 CRI-O"


}

build(){

    log_info "开始 npm run build 构建"

    # 添加sudo 权限

    log_info "开始 gem install bundler"
    sudo gem install bundler

    log_info "开始 bundle install"
    sudo bundle install
    
    log_info "开始 bundle exec jekyll build"
    sudo bundle exec jekyll build

    log_info "开始 gem build"
    sudo gem build jekyll-theme-cayman.gemspec

    pwd
    ls -lha
}


save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="cri-o.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C build .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./build"
    save_return
}

cd project_dir
if cat .git/config  |grep '/cri-o/cri-o.io.git' ;then
    log_info "匹配到 cri-o"
    before_build
    build
    #after_build 
fi
