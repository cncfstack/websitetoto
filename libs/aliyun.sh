install_aliyun_ossutil(){
  if [ ! -f ./ossutil ];then
    wget -q -O ossutil-2.0.6-beta.01091200-linux-amd64.zip  https://gosspublic.alicdn.com/ossutil/v2-beta/2.0.6-beta.01091200/ossutil-2.0.6-beta.01091200-linux-amd64.zip
    unzip ossutil-2.0.6-beta.01091200-linux-amd64.zip
    cp ossutil-2.0.6-beta.01091200-linux-amd64/ossutil ./ossutil
    chmod +x ./ossutil
  fi
}
