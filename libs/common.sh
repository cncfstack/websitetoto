
install_hugo(){
    # $OSSUTIL cp oss://cncfstack-cdn/hugo/releases/download/v0.145.0/hugo_extended_0.145.0_linux-amd64.tar.gz ./
    wget -q https://github.com/gohugoio/hugo/releases/download/v0.133.0/hugo_extended_0.133.0_linux-amd64.tar.gz
    tar xf hugo_extended_0.133.0_linux-amd64.tar.gz
}


install_hugo_v120(){
    wget -q https://github.com/gohugoio/hugo/releases/download/v0.120.0/hugo_extended_0.120.0_linux-amd64.tar.gz
    tar xf hugo_extended_0.120.0_linux-amd64.tar.gz
}


install_postcss(){
    echo "安装 postCSS"
    npm i -D postcss postcss-cli autoprefixer
}


check_cdn_change(){
    echo "=============================================> 以下文件进行了 cdn 替换，请确认文件在 https://cdn.cncfstack.com 是否存在"
    grep "cdn.cncfstack.com" ./* -R |grep -v "otocn\.sed"
}


check_not_change(){
    echo "=============================================> 以下可能的外部文件未被处理"
    # 有些图标表情使用 CDN 的 SVG，这类也可以代理。TODO：有些svg中会包含地址，这类是不需要处理的，但是会grep出来。不移除会有大量的无效信息，还是不显示svg内容，根据实际情况单独处理
    # raw.githubusercontent.com 是 github 的内容，太多输出了，有依赖单独处理吧
    grep -iE "(maxcdn.bootstrapcdn.com|code.jquery.com|cdnjs.cloudflare.com|cdn-images.mailchimp.com|cdn.jsdelivr.net|fonts.googleapis.com|unpkg.com|www.googletagmanager.com)" ./* -R |grep -vE "(\.sh\:|\.md\:|\.toml|index\.rss\.xml|README\.txt\:|otocn\.sed\:|\.svg\:|node_modules)"
}


find_and_sed(){
    # 查找可能存在外部地址的文件，
    # 对于其他文件即使包含外部地址也不需要处理，比如 svg 图片中的google字体地址
    find  . -type f -iname "*.txt" \
        -o -iname "*.md" \
        -o -iname "*.toml" \
        -o -iname "*.js" \
        -o -iname "*.mjs" \
        -o -iname "*.html" \
        -o -iname "*.css" \
        -o -iname "*.sass" \
        -o -iname "*.scss" \
        -o -iname "*.tpl" \
        -o -iname "*.rst" > ${workdir}/filelist

    # 循环依次处理可能包含外部链接的文件，并进行替换
    for file in `cat ${workdir}/filelist`
    do
        sudo sed -i -f ${initdir}/otocn.sed $file
    done

    check_cdn_change
    check_not_change
}
