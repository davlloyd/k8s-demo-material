#! /bin/bash

# Dodgy script to cleanup CAPI/CAPV kubernetes objects from a cluster removal. This is bruteforce
# at the Kubernetes object level only and does not remove the actual instances on the target platform


# Set the target namespace and cluster name values or alternatively provide them as command line arguments
# ARG 1 = Namespace
# ARG 2 = Cluster Name
# Exmaple:    ./tkg-clusterobjectcleanup.sh beta tkgm-8410-dkari-tap-jumpstart

NAMESPACE=beta
CLUSTERNAME=tkgm-8410-dkari-tap-jumpstart

if [ -n "$1" ]
then
    NAMESPACE=$1
fi


if [ -n "$2" ]
then
    CLUSTERNAME=$2
fi

function log() {
  echo -e "\n\xf0\x9f\x93\x9d     --> $*\n"
}


function cleanObject(){
    CHECK=$(kubectl get -n $NAMESPACE $1 2>&1)
    if [[ $CHECK != *"NotFound"* ]]; then
        log "Cleanup cluster object $1"
        kubectl patch $1 -n $NAMESPACE --patch='{"metadata":{"finalizers":null}}' --type 'merge' >null
        kubectl delete -n $NAMESPACE $1  >null
    fi
}

log "Get List of cluster objects"
LIST=$(kubectl get -n $NAMESPACE ma,ms,md,mhc,mp,mp,ma,cm,cb,cbt,ext,vspherecluster,cluster,vspheremachine,machine,vspherevm,kcp,secrets -o name | grep $CLUSTERNAME)

log "Target objects to be removed"
echo $LIST

log "Cleanup cluster objects"
for i in $LIST; do cleanObject $i; done

log "Get List of remaining cluster objects... if any"
LIST=$(kubectl get -n $NAMESPACE ma,ms,md,mhc,mp,mp,ma,cm,cb,cbt,ext,vspherecluster,cluster,vspheremachine,machine,vspherevm,kcp,secrets -o name | grep $CLUSTERNAME)
log "Remaining \n $LIST"

