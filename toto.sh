#!/bin/bash -x
project_giturl=$1
project_name=`echo $project_giturl |awk -F'/' '{print $NF}'|sed 's/\.git//g'`


# 每次任务创建一个目录
# 可以放松在同时构建多个项目时的冲突问题
uuid=`date  "+%s%N"`
mkdir ./tmp/${uuid} -p
workdir=./tmp/${uuid}

git clone $project_giturl $workdir


find webs -name init.sh -exec bash -x {} $workdir \;

cat ${workdir}/ret-data
echo "return src&dest"
