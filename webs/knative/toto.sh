workdir=$1
initdir=$2

set -x

source libs/common.sh


before_knative(){
    pip install -r requirements.txt

    bash -x ./hack/build.sh
}

after_knative(){

    log_info "=============================================> 当前目录中文件列表"
    ls -lh

    log_info "=============================================> development"
    ls -lh ./site/development
    log_info "=============================================> docs"
    ls -lh ./site/docs

}


save_return(){
    echo "${workdir}/site&oss://cncfstack-knative" > ${workdir}/ret-data
}

cd $workdir

if cat .git/config  |grep '/knative/docs.git' ;then
    log_info "=============================================> 匹配到 knative"
    before_knative
    after_knative
    find_and_sed_v2 "./build"
    save_return 
fi
