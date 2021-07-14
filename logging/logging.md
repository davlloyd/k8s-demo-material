

# Enabling logging to LogInsight for guest clusters

1. Edit fluent.conf file with LogInsight IP address for 'host' entry

2. Run command below to apply fluentd configuration 
*kubectl -n kube-system create configmap li-fluentd-config --from-file=fluent.conf*

3. Deploy Fluentd service
*kubectl apply -f loginsight-fluent.yml*


