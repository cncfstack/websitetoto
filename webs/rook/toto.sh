source libs/common.sh

# Rook 使用 Jeklly 的方式进行站点构建
# 通过 Makefile 进行构建：https://github.com/rook/rook.github.io/blob/master/Makefile

before_build(){
    log_info "添加网站访问统计 0d0748d9-074f-48fb-9292-91f76ac950a3 -> rook"
    # echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="0d0748d9-074f-48fb-9292-91f76ac950a3"></script>' >>  xxx
}

build(){

    # git clone https://github.com/rook/rook.git  rook_code

    # # Remove the old master docs and copy your updated docs from your rook repo
    # rm -fr docs/rook/master
    # mkdir -p docs/rook/master

    # log_info     "cp -r ./rook_code/Documentation/* docs/rook/master/"
    # cp -r ./rook_code/Documentation/* docs/rook/master/

    # ls -lha

    # make build

    git clone -b gh-pages https://github.com/rook/rook.github.io.git rook-gh-pages

}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="rook.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C rook-gh-pages .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./rook-gh-pages"
    save_return
}

cd project_dir
if cat .git/config  |grep '/rook/rook.github.io.git' ;then
    echo "匹配到 ROOK"
    before_build
    build
    after_build
fi
