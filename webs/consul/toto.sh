source libs/common.sh

before_build(){
    echo "console before build"
}

build(){

    # make -C website website-local
    

PWD=$(pwd)
DOCKER_IMAGE="hashicorp/dev-portal"
DOCKER_IMAGE_LOCAL="dev-portal-local"
DOCKER_RUN_FLAGS=-it \
		--publish "3000:3000" \
		--rm \
		--tty \
		--volume "$(PWD)/content:/app/content" \
		--volume "$(PWD)/public:/app/public" \
		--volume "$(PWD)/data:/app/data" \
		--volume "$(PWD)/redirects.js:/app/redirects.js" \
		--volume "next-dir:/app/website-preview/.next" \
		--volume "$(PWD)/.env:/app/.env" \
		-e "REPO=consul" \
		-e "PREVIEW_MODE=developer"


docker run $(DOCKER_RUN_FLAGS) $(DOCKER_IMAGE_LOCAL)


ls -lha $(PWD)/public

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
