source libs/common.sh

before_build(){

    # 在文件中没有这一行
    #sed -i "s|site_url: https://thanos.dev/docs|site_url: https://thanos.website.cncfstack.com/docs|g" website/hugo.yaml
    echo 'site_url: https://thanos.website.cncfstack.com' >> website/hugo.yaml

    # 实际在构建时会在设置URL
    sed -i "s|https://thanos.io|https://thanos.website.cncfstack.com|g" Makefile
    log_info "文档的mkdocs.yml"
    cat website/hugo.yaml

}

build(){

    make web
    pwd
    ls -lha
}


save_return(){
    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="thanos.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C website/public .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/website/${tarfile}" > ret-data
}


after_build(){
    filetoto "./website/public"
    save_return
}


cd project_dir
if cat .git/config  |grep '/thanos-io/thanos.git' ;then
    log_info "匹配到 thanos"
    before_build
    build
    after_build
fi
