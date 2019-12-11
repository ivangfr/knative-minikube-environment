#!/usr/bin/env bash

INGRESSGATEWAY=ambassador
EXTERNAL_IP_ADDRESS=$(minikube ip):$(kubectl get svc $INGRESSGATEWAY --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')

echo
echo "export EXTERNAL_IP_ADDRESS=$EXTERNAL_IP_ADDRESS"
echo
