a=$(kubectl get svc pet-clinic-build-23-55 -o json | jq -r '.status.loadBalancer.ingress[0].ip' )
b=$(kubectl get svc pet-clinic-build-23-55 -o json)
echo "1"
echo $a
echo "2"
echo $b
echo $b | jq -r '.status.loadBalancer.ingress[0].ip'
c=$( echo $b | jq -r '.status.loadBalancer.ingress[0].ip' )
echo "3"
echo $c


