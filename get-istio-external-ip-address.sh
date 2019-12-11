#!/usr/bin/env bash

INGRESSGATEWAY=istio-ingressgateway
EXTERNAL_IP_ADDRESS=$(minikube ip):$(kubectl get svc $INGRESSGATEWAY --namespace istio-system --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')

echo
echo "export EXTERNAL_IP_ADDRESS=$EXTERNAL_IP_ADDRESS"
echo
