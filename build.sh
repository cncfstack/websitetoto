# #!/bin/bash
# set -x

project=$1

source libs/common.sh

main(){
    log_info "将传入的git repo url 项目下载到指定的 project_dir 目录中"
    mkdir -p project_dir && git clone $project project_dir

    log_info "clone的仓库内容：" && ls project_dir

    log_info "根据 git url 地址匹配是 webs 中的哪个项目，匹配成功后执行该项目中的 toto.sh 文件"
    log_info "toto.sh 执行完成后，需要生成 project_dir/ret-data 文件"
    find ./webs -name toto.sh -exec /bin/bash {} \;

    log_info "检查或安装OSSUTIL，然后将文件上传文件到OSS"
    install_aliyun_ossutil

    # 由于秘钥只能在流水线中执行，因此文件传输在 action 中执行
}

main;