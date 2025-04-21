#!/bin/bash
set -x

initdir=`pwd`

source libs/common.sh
install_aliyun_ossutil

cat ${initdir}/sed/* > ${initdir}/toto.sed

for project in `cat push.list`
do
    uuid=`date  "+%s%N"`
    workdir="${initdir}/tmp/${uuid}"
    mkdir -p $workdir
    git clone $project $workdir
    log_info "=============================================>  clone的仓库内容："
    ls $workdir
    find ./webs -name toto.sh -exec /bin/bash {} $workdir \;
    src=`cat ${workdir}/ret-data|grep -v ^$|head -n 1`

    ls -lha $src

    log_info "=============================================>  上传文件到OSS"
    ./ossutil --access-key-id ${{ secrets.ALIYUN_CYG_OSS_AK }}  --access-key-secret ${{ secrets.ALIYUN_CYG_OSS_SK }}  --endpoint ${{ secrets.ALIYUN_CYG_OSS_ENDPOINT }} --region ${{ secrets.ALIYUN_CYG_OSS_REGION }}  cp -f ${src} oss://cncfstack-website/

done