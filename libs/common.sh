
# 定义颜色变量
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m'

############################################################
# log output
log_info(){
    content="[INFO] $(date '+%Y-%m-%d %H:%M:%S') $@"
    echo -e "${GREEN} ==> ${content} $NC"
}

log_warn(){
    content="[WARN] $(date '+%Y-%m-%d %H:%M:%S') $@"
    echo -e "${YELLOW} ==> ${content} $NC"
}

log_error(){
    content="[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $@"
    echo -e "${RED} ==> ${content} $NC"
    exit 1
}

install_hugo(){

    if [ -z "$1" ];then
        hugo_url="https://github.com/gohugoio/hugo/releases/download/v0.133.0/hugo_extended_0.133.0_linux-amd64.tar.gz"
    else
        hugo_url=$1
    fi
    
    pkg_name=`echo $hugo_url|awk -F'/' '{print $NF}'`

    log_info "下载并安装 hugo: $pkg_name"
    wget -q  $hugo_url -O $pkg_name
    tar xf $pkg_name

    sudo cp ./hugo /usr/bin/
    sudo chmod +x /usr/bin/hugo

    if [ ! -x "/usr/bin/hugo" ];then
        log_error " hugo 安装失败: /usr/bin/hugo 文件不存在或者没有成功设置可执行权限"
    fi
}

install_hugo_v65_3(){  
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.65.3/hugo_extended_0.65.3_Linux-64bit.tar.gz" 
}
install_hugo_v66(){    
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.66.0/hugo_extended_0.66.0_Linux-64bit.tar.gz" 
}
install_hugo_v68_3(){  
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.68.3/hugo_extended_0.68.3_Linux-64bit.tar.gz" 
}
install_hugo_v80(){    
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.80.0/hugo_extended_0.80.0_Linux-64bit.tar.gz" 
}
install_hugo_v83_1(){  
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.83.1/hugo_extended_0.83.1_Linux-64bit.tar.gz" 
}
install_hugo_v93_2(){  
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.93.2/hugo_extended_0.93.2_Linux-64bit.tar.gz" 
}
install_hugo_v99_1(){  
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.99.1/hugo_extended_0.99.1_Linux-64bit.tar.gz" 
}
install_hugo_v100_2(){ 
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.100.2/hugo_extended_0.100.2_Linux-64bit.tar.gz" 
}
install_hugo_v102_3(){ 
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.102.3/hugo_extended_0.102.3_Linux-64bit.tar.gz" 
}
install_hugo_v108(){   
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.108.0/hugo_extended_0.108.0_Linux-64bit.tar.gz" 
}
install_hugo_v111_3(){ 
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.111.3/hugo_extended_0.111.3_linux-amd64.tar.gz" 
}
install_hugo_v114(){   
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.114.0/hugo_extended_0.114.0_linux-amd64.tar.gz" 
}
install_hugo_v120(){   
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.120.0/hugo_extended_0.120.0_linux-amd64.tar.gz" 
}
install_hugo_v122(){   
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.122.0/hugo_extended_0.122.0_linux-amd64.tar.gz" 
}
install_hugo_v124_1(){ 
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.124.1/hugo_extended_0.124.1_linux-amd64.tar.gz" 
}
install_hugo_v136_5(){ 
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.136.5/hugo_extended_0.136.5_linux-amd64.tar.gz" 
}
install_hugo_v139_3(){ 
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.139.3/hugo_extended_0.139.3_linux-amd64.tar.gz" 
}
install_hugo_v143_1(){ 
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.143.1/hugo_extended_0.143.1_linux-amd64.tar.gz" 
}
install_hugo_v145(){   
    install_hugo "https://github.com/gohugoio/hugo/releases/download/v0.145.0/hugo_extended_0.145.0_linux-amd64.tar.gz" 
}


install_postcss(){
    log_info "安装 postCSS"
    npm i -D postcss postcss-cli autoprefixer
}



check_cdn_change(){
    log_info "=============================================> 以下文件进行了 cdn 替换，请确认文件在 https://cdn.cncfstack.com 是否存在"
    grep "filetoto.cncfstack.com" ./* -R |grep -v "otocn\.sed"|awk -F':' '{print $1}'
}


check_not_change(){
    log_info "=============================================> 以下可能的外部文件未被处理"
    # 有些图标表情使用 CDN 的 SVG，这类也可以代理。TODO：有些svg中会包含地址，这类是不需要处理的，但是会grep出来。不移除会有大量的无效信息，还是不显示svg内容，根据实际情况单独处理
    # raw.githubusercontent.com 是 github 的内容，太多输出了，有依赖单独处理吧
    grep -iEo "(maxcdn.bootstrapcdn.com|code.jquery.com|cdnjs.cloudflare.com|cdn-images.mailchimp.com|cdn.jsdelivr.net|fonts.googleapis.com|unpkg.com|www.googletagmanager.com)" ./* -R |grep -vE "(\.sh\:|\.md\:|\.toml|index\.rss\.xml|README\.txt\:|otocn\.sed\:|\.svg\:|node_modules)" 
}


# find_and_sed(){
#     # 查找可能存在外部地址的文件，
#     # 对于其他文件即使包含外部地址也不需要处理，比如 svg 图片中的google字体地址
#     find  . -type f \( -iname "*.txt" \
#         -o -iname "*.md" \
#         -o -iname "*.toml" \
#         -o -iname "*.js" \
#         -o -iname "*.mjs" \
#         -o -iname "*.html" \
#         -o -iname "*.css" \
#         -o -iname "*.sass" \
#         -o -iname "*.scss" \
#         -o -iname "*.tpl" \
#         -o -iname "*.rst" \) > ${workdir}/filelist

#     cat ${workdir}/../sed/* > ${workdir}/../toto.sed

#     # 循环依次处理可能包含外部链接的文件，并进行替换
#     for file in `cat ${workdir}/filelist`
#     do
#         sudo sed -i -f toto.sed $file
#     done

#     check_cdn_change
#     check_not_change
# }

# 可以指定处理的路径，这在构建完成后再进行替换时很有用
find_and_sed_v2(){
    path=$1
    # 查找可能存在外部地址的文件，
    # 对于其他文件即使包含外部地址也不需要处理，比如 svg 图片中的google字体地址
    find  $path -type f -iname "*.txt" \
        -o -iname "*.md" \
        -o -iname "*.toml" \
        -o -iname "*.js" \
        -o -iname "*.mjs" \
        -o -iname "*.html" \
        -o -iname "*.css" \
        -o -iname "*.sass" \
        -o -iname "*.scss" \
        -o -iname "*.tpl" \
        -o -iname "*.rst" > wil-sed-file-list

    cat ../sed/* > toto.sed

    # 循环依次处理可能包含外部链接的文件，并进行替换
    for file in `cat wil-sed-file-list`
    do
        sudo sed -i -f toto.sed $file
    done

    check_cdn_change
    #check_not_change
}



find_and_sed_v3(){
    path=$1

    log_info “查找可能存在外部地址的文件，对于其他文件即使包含外部地址也不需要处理，比如 svg 图片中的google字体地址”
    find  $path -type f -iname "*.txt" \
        -o -iname "*.md" \
        -o -iname "*.toml" \
        -o -iname "*.js" \
        -o -iname "*.mjs" \
        -o -iname "*.html" \
        -o -iname "*.css" \
        -o -iname "*.sass" \
        -o -iname "*.scss" \
        -o -iname "*.tpl" \
        -o -iname "*.rst" > wil-sed-file-list

    log_info "通过find查找到需要进行替换的文件列表："
    cat wil-sed-file-list

    log_info "获取替换的 sed 文件："
    curl -fsSL https://raw.githubusercontent.com/cncfstack/filetoto/refs/heads/main/allfile.list -o allfile.list
    curl -fsSL https://raw.githubusercontent.com/cncfstack/filetoto/refs/heads/main/alldomains -o alldomains

    cat allfile.list|awk -F'https://' '{print "s|"$0"|https://filetoto.cncfstack.com/"$2"|g"}' > toto.sed
    cat alldomains|awk -F'https://' '{print "s|"$0"|https://filetoto.cncfstack.com/"$2"|g"}' >> toto.sed

    cat toto.sed
    # cat ../sed/* > toto.sed

    # 循环依次处理可能包含外部链接的文件，并进行替换
    for file in `cat wil-sed-file-list`
    do
        sudo sed -i -f toto.sed $file
    done

    log_info "以下文件内容进行了替换"
    grep "filetoto.cncfstack.com"  $path  -R 

}

install_aliyun_ossutil(){
  if [ ! -f ./ossutil ];then
    log_info "当前路径下无 ossutil，下载并安装到本地 ./ossutil 和 /usr/bin/ossutil"
    wget -q -O ossutil-2.0.6-beta.01091200-linux-amd64.zip  https://gosspublic.alicdn.com/ossutil/v2-beta/2.0.6-beta.01091200/ossutil-2.0.6-beta.01091200-linux-amd64.zip
    unzip ossutil-2.0.6-beta.01091200-linux-amd64.zip
    cp ossutil-2.0.6-beta.01091200-linux-amd64/ossutil ./ossutil
    chmod +x ./ossutil
    sudo cp ./ossutil /usr/bin/
  fi
}

debug_tools(){
    log_info "===debug info"
    ls -lha
    pwd
    log_info "===debug info"
}