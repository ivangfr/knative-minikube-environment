#!/usr/bin/env bash

# This script was implemented based on the Knative Official Documentation (v.0.10)
# - Installing Knative with Ambassador: https://knative.dev/docs/install/knative-with-ambassador/

echo
echo "Installing Knative"
echo "=================="

echo
echo "Install Knative CRDs"
echo "--------------------"

kubectl apply --filename https://github.com/knative/serving/releases/download/v0.10.0/serving-crds.yaml

echo
echo "Complete install of Knative and its dependencies"
echo "------------------------------------------------"

kubectl apply --filename https://github.com/knative/serving/releases/download/v0.10.0/serving-core.yaml


echo
echo "Installing Ambassador"
echo "====================="

kubectl apply \
  --filename https://getambassador.io/yaml/ambassador/ambassador-knative.yaml \
  --filename https://getambassador.io/yaml/ambassador/ambassador-service.yaml

echo
echo "Ambassador External IP Address"
echo "------------------------------"

INGRESSGATEWAY=ambassador
EXTERNAL_IP_ADDRESS=$(minikube ip):$(kubectl get svc $INGRESSGATEWAY --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')

echo "EXTERNAL_IP_ADDRESS=$EXTERNAL_IP_ADDRESS"

echo
echo "Knative-Ambassador setup completed successfully"
echo "==============================================="
echo
echo "To verify Readiness and Status of all pods : kubectl get pods --all-namespaces"
echo "To export Ambassador External IP Address   : export EXTERNAL_IP_ADDRESS=$EXTERNAL_IP_ADDRESS"
echo
