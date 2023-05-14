
kubectl create ns tanzu-system-ingress
kubectl create ns tanzu-system-monitoring
kubectl create ns tanzu-system-dashboards
tanzu package repository add standard-package-repo --url projects-stg.registry.vmware.com/tkg/packages/standard/repo:v2.2.0-20230418 --namespace tkg-system
tanzu package install cert-manager --package cert-manager.tanzu.vmware.com --version 1.7.2+vmware.1-tkg.1 --namespace tkg-system
tanzu package install contour --package contour.tanzu.vmware.com --version 1.23.5+vmware.1-tkg.1-20230418 --values-file ./contour-values.yml --namespace tanzu-system-ingress
tanzu package install prometheus --package prometheus.tanzu.vmware.com --version 2.36.2+vmware.1-tkg.1 --values-file ./prometheus-data-values.yaml --namespace tanzu-system-monitoring
tanzu package install grafana --package grafana.tanzu.vmware.com --version 7.5.16+vmware.1-tkg.1 --values-file grafana-data-values.yaml --namespace tanzu-system-dashboards
