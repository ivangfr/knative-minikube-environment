#!/usr/bin/env bash

# This script was implemented based on the Knative Official Documentation (v1.3): https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/

echo
echo "Installing Knative Serving using YAML files"
echo "==========================================="

echo
echo "Install the Knative Serving component"
echo "-------------------------------------"

echo
echo "Install the required custom resources"
echo "-------------------------------------"

kubectl apply --filename https://github.com/knative/serving/releases/download/knative-v1.3.2/serving-crds.yaml

echo
echo "Install the core components of Knative Serving"
echo "----------------------------------------------"

kubectl apply --filename https://github.com/knative/serving/releases/download/knative-v1.3.2/serving-core.yaml

echo
echo "Install a networking layer"
echo "=========================="

echo
echo "Install the Knative Kourier controller"
echo "--------------------------------------"

kubectl apply --filename https://github.com/knative/net-kourier/releases/download/knative-v1.3.0/kourier.yaml

echo
echo "Configure Knative Serving to use Kourier by default"
echo "---------------------------------------------------"

kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'

echo
echo "Fetch the External IP address or CNAME"
echo "--------------------------------------"

EXTERNAL_IP_ADDRESS=$(minikube ip):$(kubectl get service kourier --namespace kourier-system --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')

echo
echo "Knative Serving setup completed successfully"
echo "============================================"
echo
echo "To watch Readiness and Status of all pods (Ctrl+C to stop) : kubectl get pods --all-namespaces --watch"
echo "To export Kourier External IP Address                      : export EXTERNAL_IP_ADDRESS=$EXTERNAL_IP_ADDRESS"
echo
