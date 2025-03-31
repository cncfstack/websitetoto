
install_aliyun_ossutil(){
  if [ ! -f ./ossutil ];then
    log_info "=============================================> 当前路径下无 ossutil，下载并安装到本地 ./ossutil 和 /usr/bin/ossutil"
    wget -q -O ossutil-2.0.6-beta.01091200-linux-amd64.zip  https://gosspublic.alicdn.com/ossutil/v2-beta/2.0.6-beta.01091200/ossutil-2.0.6-beta.01091200-linux-amd64.zip
    unzip ossutil-2.0.6-beta.01091200-linux-amd64.zip
    cp ossutil-2.0.6-beta.01091200-linux-amd64/ossutil ./ossutil
    chmod +x ./ossutil
    sudo cp ./ossutil /usr/bin/
  fi
}
