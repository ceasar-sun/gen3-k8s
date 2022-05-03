#!/bin/bash
# Script to create and re-create es indices and setup guppy

ESPROXY_POD=`kubectl get pod -l app=esproxy -o jsonpath='{.items[0].metadata.name}'`

sleep 2
kubectl exec $ESPROXY_POD -c esproxy -- curl -X DELETE http://localhost:9200/etl_0
sleep 2
kubectl exec $ESPROXY_POD -c esproxy -- curl -X DELETE http://localhost:9200/file_0
sleep 2
kubectl exec $ESPROXY_POD -c esproxy -- curl -X DELETE http://localhost:9200/file-array-config_0
sleep 2
kubectl exec $ESPROXY_POD -c esproxy -- curl -X DELETE http://localhost:9200/etl-array-config_0
sleep 2

TUBE_POD=`kubectl get pod -l app=tube -o jsonpath='{.items[0].metadata.name}'`

kubectl exec $TUBE_POD -- bash -c "python run_config.py && python run_etl.py"

GUPPY_POD=`kubectl get pod -l app=guppy -o jsonpath='{.items[0].metadata.name}'`
kubectl delete pod $GUPPY_POD

