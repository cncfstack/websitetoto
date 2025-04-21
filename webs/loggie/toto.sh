workdir=$1

source ${initdir}/libs/common.sh

before_build(){

    # 添加网站访问统计
    cat > overrides/main.html <<EOF
{% extends "base.html" %}
{% block htmltitle %}
  <script defer src="https://umami.cncfstack.com/script.js" data-website-id="efec053d-80c8-422f-b0e4-bdaa970e370b"></script>
  <title>Loggie</title>
{% endblock %}
EOF

}

build(){
    echo "after_loggie"
    sudo docker run --rm -v ${PWD}:/docs squidfunk/mkdocs-material  build

    # 特殊情况，在构建完成后的文件中包含emoji表情svg文件，这这构建前是不可知道的，所以在构建完成后再替换一次。
    find_and_sed

}


save_return(){

    tar czvf loggie.tgz site/*
    
    if [ ! -s loggie.tgz ];then
        log_error "Loggie 站点构建失败"
    fi

    # 这行很重要，在其他关联项目中，文件名称必须要匹配
    echo "${workdir}/loggie.tgz" > ${workdir}/ret-data
}





cd $workdir
if cat .git/config  |grep '/loggie-io/docs.git' ;then
    echo "=============================================> 匹配到 loggie"
    before_build
    find_and_sed
    build
    save_return 
fi

