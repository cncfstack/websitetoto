source libs/common.sh


before_build(){
    # Kubernetes
    ########################################
    
    echo "=============================================> 构建前准备 Kubernetes"

    # 在使用GitHub构建时不需要这个步骤，因为每次构建都是新环境；并且会移除前面步骤下载的 ossutil
    # git reset --hard
    # git clean -df
    # git pull --rebase

    # echo "K8s 使用扩展的docsy主题，使用特有的镜像吗？"
    sudo mkdir  project_dir/docsy
    sudo docker run -itd --name docsy-tmp gcr.io/k8s-staging-sig-docs/k8s-website-hugo:v0.133.0-1b9242684415 /bin/sh
    sudo docker cp docsy-tmp:/src/node_modules node_modules
    sudo docker stop docsy-tmp
    sudo docker rm docsy-tmp


    echo "install hugo"
    install_hugo


    # 拉取 downloadkubernetes 仓库获取release_binaries.json文件
    # 这一步是因为原始的文档是从 raw.githubusercontent.com 获取的，但是这个地址被墙了，所以需要从 downloadkubernetes 仓库获取release_binaries.json文件，然后替换原始的文档中的release_binaries.json文件。
    git clone https://github.com/kubernetes-sigs/downloadkubernetes.git
    cd downloadkubernetes && git pull --rebase && cd -
    ./ossutil cp -f downloadkubernetes/dist/release_binaries.json oss://cncfstack-www/project/kubernetes-doc/release_binaries.json

    # step2
    # 1、替换kubernetes文档原始的文档中的release_binaries.json文件链接
    # 2、修改hugo构建超时时间，默认180秒太短了
    # 上次更新会修改文件，所有需要先丢弃所有git更新，然后与远程仓库同步

    # 1、替换
    sed  -i 's#https://raw.githubusercontent.com/kubernetes-sigs/downloadkubernetes/master/dist/release_binaries.json#https://cncfstack.com/project/kubernetes-doc/release_binaries.json#g'   ./layouts/shortcodes/release-binaries.html

    # 2、修改hugo超时时间
    sed -i -e 's#timeout = "180s"#timeout = "3600s"#g' \
        -e 's#https://storage.googleapis.com/k8s-cve-feed/official-cve-feed.json#https://cncfstack.com/cdn/official-cve-feed.json#' \
    ./hugo.toml

    # 3、修改网址的声明内容
    # 中文的 京ICP备17074266号-3 需要替换
    sed -i 's#京ICP备17074266号-3#浙ICP备2025154934号#g' ./layouts/partials/footer.html

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="955c801b-d883-48ff-83fd-d0757b21b321"></script>' >>   layouts/partials/hooks/body-end.html


}

build(){
    # Kubernetes build
    ########################################

    echo "=============================================> 开始构建 /kubernetes/website.git"

    # step3
    # 开始编译文档
    # 注意：这里的容器镜像后面版本1b9242684415ID和仓库的Makefile等文件的sha256的前12位，所以镜像可能会变动
    # 由于docker使用sudo创建的目录是root权限，无法读写，现删除在用普通用户创建
    
    # sudo docker run --rm \
    # -v "`pwd`/.git:/src/.git" \
    # -v "`pwd`/archetypes:/src/archetypes" \
    # -v "`pwd`/assets:/src/assets" \
    # -v "`pwd`/content:/src/content" \
    # -v "`pwd`/data:/src/data" \
    # -v "`pwd`/i18n:/src/i18n" \
    # -v "`pwd`/layouts:/src/layouts" \
    # -v "`pwd`/static:/src/static" \
    # -v "`pwd`/hugo.toml:/src/hugo.toml" \
    # -v "`pwd`/website-site:/src/website-site:Z" \
    # -v "`pwd`/docsy:/src/node_modules/docsy:Z" \
    # gcr.io/k8s-staging-sig-docs/k8s-website-hugo:v0.133.0-1b9242684415 \
    # hugo \
    # --destination /src/website-site \
    # --cleanDestinationDir \
    # --buildFuture \
    # --noBuildLock \
    # --minify \
    # --logLevel debug \
    # --debug \
    # --printI18nWarnings \
    # --printMemoryUsage \
    # --printPathWarnings \
    # --printUnusedTemplates \
    # --templateMetrics  \
    # --templateMetricsHints \
    # --baseURL http://k8.cncfstack.com

    mkdir website-site
    
    ./hugo \
    --destination ./website-site \
    --cleanDestinationDir \
    --buildFuture \
    --noBuildLock \
    --minify \
    --printI18nWarnings \
    --printMemoryUsage \
    --printPathWarnings \
    --printUnusedTemplates \
    --templateMetrics  \
    --templateMetricsHints \
    --baseURL https://kubernetes.website.cncfstack.com



    # 构建完成后无法找到该js文件
    mkdir -p website-site/pagefind

    wget https://kubernetes.io/pagefind/pagefind-ui.js -O website-site/pagefind/pagefind-ui.js
    wget https://kubernetes.io/pagefind/pagefind.js  -O website-site/pagefind/pagefind.js
    wget https://kubernetes.io/pagefind/pagefind-entry.json -O  website-site/pagefind/pagefind-entry.json
    wget https://kubernetes.io/pagefind/pagefind.zh-cn_9145a968ac6ff.pf_meta -O website-site/pagefind/pagefind.zh-cn_9145a968ac6ff.pf_meta
    
}



save_return(){
    # echo "${workdir}/website-site&oss://cncfstack-k8s" > ${workdir}/ret-data

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="kubernetes.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C website-site .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}
}


cd project_dir
if cat .git/config  |grep '/kubernetes/website.git' ;then
echo "匹配到 kubernetes"
    before_build
    find_and_sed
    build
    save_return 
fi
