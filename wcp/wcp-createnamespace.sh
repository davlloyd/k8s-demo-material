#!/bin/bash

VCENTER='vcenter.home.local'
ACCOUNT='administrator@vsphere.local'
PWD='B3ach8um!'

OWNERACCOUNTNAME='administrator'
OWNERACCOUNTDOMAIN='vsphere.local'

STORAGEPOLICY='wcp-storage-general'
MEMLIMIT='10000'
CPULIMIT='5000'
CLUSTER='Cluster1'
NAMESPACE='test6'

#login
echo "Login to $VCENTER"
AUTH=$(echo -n "$ACCOUNT:$PWD" | base64)
SESSIONID=$(curl -s -X  POST "https://$VCENTER/rest/com/vmware/cis/session" -H 'Content-type: application/json' -H "Authorization: Basic $AUTH" -H 'Accept: application/json' -H 'vmware-use-header-authn: test' -H 'vmware-api-session-id: null' | jq '.value')
SESSIONID=`echo $SESSIONID | sed 's/.\(.*\)/\1/' | sed 's/\(.*\)./\1/'`
echo "Session ID: $SESSIONID"

#get storage policy id
POLICYID=$(curl -s -X GET "https://$VCENTER/rest/vcenter/storage/policies" -H 'Content-type: application/json' -H "vmware-api-session-id: $SESSIONID" | jq --arg sp "$STORAGEPOLICY" '.value[] | select(.name == $sp) | .policy')
POLICYID=`echo $POLICYID | sed 's/.\(.*\)/\1/' | sed 's/\(.*\)./\1/'`
echo "StoragePolicy ID: $POLICYID"

#get cluster id
CLUSTERID=$(curl -s -X GET "https://$VCENTER/api/vcenter/namespace-management/clusters" -H 'Content-type: application/json' -H "vmware-api-session-id: $SESSIONID"  | jq '.[0].cluster')
CLUSTERID=`echo $CLUSTERID | sed 's/.\(.*\)/\1/' | sed 's/\(.*\)./\1/'`
echo "Cluster ID: $POLICYID"

# Define permissions 
ACCESSLIST="[{\"role\": \"EDIT\",\"subject_type\": \"USER\",\"subject\": \"$OWNERACCOUNTNAME\",\"domain\": \"$OWNERACCOUNTDOMAIN\"}]"
# Set Quotas
RESOURCESPEC="{\"cpu_limit\": $CPULIMIT,\"memory_limit\" : $MEMLIMIT}"
# Definte Storage Access
STORAGESPEC="[{\"policy\": \"$POLICYID\"}]"
# Create payload
NSDATA="{\"namespace\": \"$NAMESPACE\", \"cluster\": \"$CLUSTERID\", \"access_list\": $ACCESSLIST, \"storage_specs\": $STORAGESPEC, \"resource_spec\": $RESOURCESPEC }"

# Create namespace
curl -s -X POST -H "Content-Type: application/json"  -H "vmware-api-session-id: $SESSIONID" -d "$NSDATA" "https://$VCENTER/api/vcenter/namespaces/instances"


