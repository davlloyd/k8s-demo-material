#!/bin/bash

# Script:       redis-vm-tune.sh
# Purpose:      Increase overall VM/K8s worker node performance specific to Latency sensitive workloasd such as Redis
# Version:      0.2b
# Description:  Script sets performance tuning settings to listed VMs or all VMs in the listed folder
#               Settings will apply to VMs if PoweredOn but I restart will be required to activate the latency sensitive tunable
# Requirement:  utilises VMware GoLang 'govmomi' library cli govc (https://github.com/vmware/govmomi/tree/master/govc)
# Updates:      0.2b added numaaffinty and changed coalescing scheme from disabled to support higher interupt rate of 16000

export GOVC_INSECURE=1
export GOVC_URL=https://vcenter1.home.local
export GOVC_USERNAME=administrator@vsphere.local
export GOVC_PASSWORD=B3ach8um!

vmListType='folder'  # Set valuie to folder or list... folder will query the vm folder and apply the changes to all VMs
dataCenter='Home'
vmFolder='kube'
cluster='Cluster1'
targetVMS="k8s-worker-1 k8s-worker-2 k8s-worker-3"      # space seperated list of VM names to have change applied


# Query vCneter for VM list of 
if [ $vmListType == 'folder' ] || [ $vmListType == 'FOLDER' ]
then
    vms=$(govc ls /${dataCenter}/vm/${vmFolder})
    vms=($vms)
else
    vms=($targetVMS)
fi

# Get CPU clock speed
hostpath="/${dataCenter}/host/${cluster}"
randomHost=$(govc ls -t HostSystem ${hostpath} | head -1)
cpuMhz=$(govc object.collect -s ${randomHost}  summary.hardware.cpuMhz)

for vm in "${vms[@]}";
do
    if [ $vmListType == 'list' ] || [ $vmListType == 'LIST' ]
    then
        vmPath="/${dataCenter}/vm/${vmFolder}/${vm}"
    else
        vmPath=$vm
    fi

    echo $vmPath

    # Set memory reservation
    memReservation=$(govc object.collect -s ${vmPath} summary.config.memorySizeMB)
    cmd="govc vm.change -vm ${vmPath} -mem.reservation ${memReservation}"
    eval $cmd

    # Set CPU reservation
    coreCount=$(govc object.collect -s ${vmPath} summary.config.numCpu)
    cpuReservation=$(expr $coreCount \* $cpuMhz)
    cmd="govc vm.change -vm ${vmPath} -cpu.reservation ${cpuReservation}"
    eval $cmd

    # Enable Latency Sensitivy
    cmd="govc vm.change -vm ${vmPath} -e sched.cpu.latencySensitivity=high"
    eval $cmd

    # Set coalescing Scheme
    cmd="govc vm.change -vm ${vmPath} -e ethernetX.coalescingScheme=rbc"
    eval $cmd

    # Set interupt rate to align to higher packet rate 
    cmd="govc vm.change -vm ${vmPath} -e ethernetX.coalescingParams=16000"
    eval $cmd

    # Set NUMA Affinty (this really needs to be dynamic to ensure ballance)
    cmd="govc vm.change -vm ${vmPath} -e numa.nodeAffinity=0"
    eval $cmd

done
