workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_loggie(){

    # 添加网站访问统计

    cat > overrides/main.html <<EOF
{% extends "base.html" %}
{% block htmltitle %}
  <script defer src="https://umami.cncfstack.com/script.js" data-website-id="efec053d-80c8-422f-b0e4-bdaa970e370b"></script>
  <title>Loggie</title>
{% endblock %}
EOF
    
}

after_loggie(){
    echo "after_loggie"
    sudo docker run --rm -v ${PWD}:/docs squidfunk/mkdocs-material  build

    # 特殊情况，在构建完成后的文件中包含emoji表情svg文件，这这构建前是不可知道的，所以在构建完成后再替换一次。
    find_and_sed

#    $OSSUTIL cp -fr site oss://cncfstack-loggie
}



save_return(){
    echo "${workdir}/site&oss://cncfstack-loggie" > ${workdir}/ret-data
}


cd $workdir


if cat .git/config  |grep '/loggie-io/docs.git' ;then
    echo "/loggie-io/docs.git"
    before_loggie
    find_and_sed
    after_loggie
    save_return 
fi

