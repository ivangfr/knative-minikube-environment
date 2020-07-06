#!/usr/bin/env bash

EXTERNAL_IP_ADDRESS=$(minikube ip):$(kubectl get svc kong-proxy --namespace kong --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')

echo
echo "export EXTERNAL_IP_ADDRESS=$EXTERNAL_IP_ADDRESS"
echo
