source libs/common.sh

before_build(){
    echo "console before build"
}

build(){

    # make -C website website-local
    

    docker run -it \
    --publish "3000:3000" \
    --rm \
    --tty \
    --volume "`pwd`/content:/app/content" \
    --volume "`pwd`/public:/app/public" \
    --volume "`pwd`/data:/app/data" \
    --volume "`pwd`/redirects.js:/app/redirects.js" \
    --volume "next-dir:/app/website-preview/.next" \
    --volume "`pwd`/.env:/app/.env" \
    -e "REPO=consul" \
    -e "PREVIEW_MODE=developer" \
    dev-portal-local

    ls -lha `pwd`/public

}


save_return(){
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="consul.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C website/public .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}


after_build(){
    filetoto "./website/public"
    save_return
}


cd project_dir
if cat .git/config  |grep '/hashicorp/consul.git' ;then
    log_info "匹配到 consul"
    before_build
    build
    after_build
fi
