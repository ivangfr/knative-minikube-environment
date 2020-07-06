#!/usr/bin/env bash

# This script was implemented based on the Knative Official Documentation (v0.15)


echo
echo "Installing Knative & Kong"
echo "========================="

echo
echo "Installing the Serving component"
echo "--------------------------------"

echo
echo "Install the Custom Resource Definitions (aka CRDs)"
echo "--------------------------------------------------"

kubectl apply --filename https://github.com/knative/serving/releases/download/v0.15.0/serving-crds.yaml

echo
echo "Install the core components of Serving"
echo "--------------------------------------"

kubectl apply --filename https://github.com/knative/serving/releases/download/v0.15.0/serving-core.yaml


echo
echo "Install Kong Ingress Controller"
echo "-------------------------------"

kubectl apply --filename https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/0.9.x/deploy/single/all-in-one-dbless.yaml

echo
echo "To configure Knative Serving to use Kong by default"
echo "---------------------------------------------------"

kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress.class":"kong"}}'

echo
echo "Kong External IP Address"
echo "------------------------"

EXTERNAL_IP_ADDRESS=$(minikube ip):$(kubectl get svc kong-proxy --namespace kong --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')

echo
echo "Knative & Kong setup completed successfully"
echo "==========================================="
echo
echo "To verify Readiness and Status of all pods : kubectl get pods --all-namespaces"
echo "To export Kong External IP Address         : export EXTERNAL_IP_ADDRESS=$EXTERNAL_IP_ADDRESS"
echo
