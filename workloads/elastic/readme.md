1) kubectl create ns elk
2) apply PVC
3) kubectl create configmap elasticsearch-config --from-file=elasticsearch.yml -n elk
4) apply deployment 