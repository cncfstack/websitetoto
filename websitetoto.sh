#!/bin/bash -x
project_list=$1

for project in `cat $project_list`
do
    project_name=`echo $project |awk -F'/' '{print $NF}'|sed 's/\.git//g'`
    #git clone $project
    #cd $project_name
    echo  ${{ secrets.TEST1 }}
done

