#!/usr/bin/env bash

EXTERNAL_IP_ADDRESS=$(minikube ip):$(kubectl get svc kourier --namespace kourier-system --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')

echo
echo "EXTERNAL_IP_ADDRESS=$EXTERNAL_IP_ADDRESS"
echo
