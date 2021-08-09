# CNR aligned hints and demo commands


## Load Simulation
siege -c 100 -r 100 -H "Host: helloworld-go.default.faas.home.local" helloworld-go.default.faas.home.local



## Setting up the default broker with RabbitMQ to capture vSphere events

1) Set target namespace env variable "WORKLOAD_NAMESPACE"  
    *export WORKLOAD_NAMESPACE=default*

2) Create RabbitMQ Cluster 
    *kubectl apply -f 1-event-rabbitmq-cluster.yaml*

3) Create a broker for RabbitMQ 
    *kubectl apply -f 2-event-rabbitmq-broker.yaml*

4) Create a consumer for the events
    *kubectl apply -f 3-event-consumer.yaml*

5) Create an event trigger 
    *kubectl apply -f 4-event-trigger.yaml*

6) Create the vsphere source to pass events
    *kubectl apply -f 5-source-vsphere-cred-secret.yaml*
    *kubectl apply -f 6-source-vsphere-source.yaml*

7) Watch events
    kubectl logs -l serving.knative.dev/service=event-display -c user-container -n ${WORKLOAD_NAMESPACE} --since=10m --tail=50 --follow

