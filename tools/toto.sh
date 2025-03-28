workdir=$1
initdir=$2

source ${initdir}/libs/common.sh

before_helm_website(){}

after_helm_website(){}

save_return(){
    echo "${workdir}/app&oss://cncfstack-helm" > ${workdir}/ret-data
}


cd $workdir
if cat .git/config  |grep '/helm/helm-www.git' ;then
    echo "helmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"
    before_helm_website
    find_and_sed
    after_helm_website
    save_return 
fi
