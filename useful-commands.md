## Access to TKGs clusters
SSH Node Username:      vmware-system-user
SSH Node Password:      kubectl get secret <clustername>-ssh-password -o jsonpath='{.data.ssh-passwordkey}' -n <namespace> | base64 -D
Kubeconfig-admin:       kubectl get secret -n <namespace> <clustername>-kubeconfig -o jsonpath='{.data.value}' | base64 -d


## TKG Node Time
systemctl status systemd-timesyncd
/etc/systemd/timesyncd.conf (default)
/etc/systemd/timesyncd.conf.d/cloud-init.conf (cloud-init template append)


# SSH Client Pod
kubectl run -i --tty --rm jumppod --image=kroniak/ssh-client --restart=Never -n <namespace> -- sh

## controler VM root password
from VC:    /usr/lib/vmware-wcp/decryptK8Pwd.py

# read cloud -init settings for node
kubectl get cm -n core core1-control-plane-6w2zr-jwsx7-cloud-init -o json | jq '.data."guestinfo.userdata"' -r | base64 -d


# delete failed pods (all namespaces)
kubectl get po -A --field-selector status.phase!=Succeeded,status.phase!=Running,status.phase!=Pending -o json | kubectl delete -f -
or
kubectl get po -A --field-selector status.phase==Failed -o json | kubectl delete -f -
