source libs/common.sh

before_build(){

    # install_hugo_v68_3
    install_hugo_v68_3
    npm install
    # python pull_external.py

    # pipenv run python pull_external.py

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="86f12ca0-83a8-470a-af6c-6ba96d72998e"></script>' >>  layouts/partials/meta.html


# RUN curl https://pyenv.run | bash
# RUN export PATH="$(pyenv root)/shims/python:$PATH"
# RUN echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
#  pyenv install
#   pyenv global $(cat .python-version)
#   pyenv exec pip install pipenv --user
#   RUN export PIPENV_PYTHON="$(pyenv root)/shims/python"
# RUN pipenv sync --dev
# CMD [ "pipenv run bash run.sh" ]

    log_info "构建本地开发镜像"
    make docker-build

}

build(){

    #npm run build:production

    # mkdir public
    # hugo \
    # --destination ./public \
    # --cleanDestinationDir \
	# --buildDrafts \
	# --buildFuture \
    # --minify \
    # --gc \
    # --enableGitInfo \
    # --baseURL https://spiffe.website.cncfstack.com
    # make setup
    # make production-build

    cat > cncfstack-build.sh <<EOF
#!/usr/bin/env bash -x

# Installs npm dependencies
npm install

# Pulls in external content
pipenv run python pull_external.py

./hugo \
    --cleanDestinationDir \
    --minify \
    --baseURL https://spiffe.website.cncfstack.com
EOF

    chmod +x cncfstack-build.sh

    log_info "使用本地开发镜像镜像构建"

    docker run -itd  --name tmp -v `pwd`:/app:Z --entrypoint="/bin/bash" spiffe.io:latest  -c  "pipenv run bash cncfstack-build.sh"

    docker inspect tmp

    docker ps -a

    docker logs -f tmp


    debug_tools
}

save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="spiffe.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C public .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data

}

after_build(){
    filetoto "./public"
    save_return
}

cd project_dir
if cat .git/config  |grep '/spiffe/spiffe.io.git' ;then
    echo "匹配到 spiffe"
    before_build
    build
    after_build 
fi
