#!/bin/bash
# IP of the node on the same pod as the
# testbed 'redis-benchmark'
IP_SAME_NODE_POD="172.20.0.56"
IP_DIFFERENT_NODE_POD="172.20.3.8"
IP_DIFFERENT_NODE_DIFFERENT_HOST_POD="172.20.4.9"
# Tests to run; leave blank for full gamut
TESTS_TO_RUN="get,set"
echo "--------- TEST CASE 1 | LOCALHOST"
redis-benchmark -c 1 -n 100000 -d 3 -t $TESTS_TO_RUN -q
echo "--------- TEST CASE 2 | TWO PODs, SAME WORKER NODE - ONE PHYSICAL HOST"
redis-benchmark -c 1 -n 100000 -d 3 -t $TESTS_TO_RUN -h $IP_SAME_NODE_POD -q
echo "--------- TEST CASE 3 | TWO PODs, SEPARATE WORKER NODES - ONE HOST"
redis-benchmark -c 1 -n 100000 -d 3 -t $TESTS_TO_RUN -h $IP_DIFFERENT_NODE_POD -q
echo "--------- TEST CASE 4 | TWO PODs, SEPARATE WORKER NODES - SEPARATE HOSTS"
redis-benchmark -c 1 -n 100000 -d 3 -t $TESTS_TO_RUN -h $IP_DIFFERENT_NODE_DIFFERENT_HOST_POD -q
echo "--------- LATENCY ---------"


