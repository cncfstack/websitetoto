source libs/common.sh

before_build(){
    echo "npm install"
    
    install_hugo_v57_2
    install_postcss
    npm install

    # 添加网站访问统计
    echo '<script defer src="https://umami.cncfstack.com/script.js" data-website-id="8ccc7a7d-06b8-477d-9d25-eb27c0ac9bbc"></script>' >> layouts/partials/favicons.html

    # 文件语法错误，无法编译
    # rm -f content/zh/blog/*
    # rm -f content/en/blog/*

}

build(){
    mkdir website-site

    ./hugo \
    --destination ./website-site \
    --cleanDestinationDir \
    --environment production \
    --minify \
    --baseURL https://volcano.website.cncfstack.com
}



save_return(){

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    tarfile="volcano.tgz"

    # 进入到site目录后进行打包，这样是为了便于部署时解压
    tar -czf ${tarfile} -C website-site .

    if [ ! -s ${tarfile} ];then
        log_error "站点构建失败"
    fi

    debug_tools
    
    log_info "站点构建完成"

    echo "project_dir/${tarfile}" > ret-data
}

after_build(){
    filetoto "./website-site"
    save_return
}

cd project_dir
if cat .git/config  |grep '/volcano-sh/website.git' ;then
    echo "匹配到 volcano"
    before_build
    build
    after_build 
fi
