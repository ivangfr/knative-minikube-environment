#!/usr/bin/env bash

echo
echo "Uninstalling Knative"
echo "===================="

# Note: Monitoring was disabled because it's too heavy for Minikube
kubectl delete \
   --filename https://github.com/knative/serving/releases/download/v0.11.0/serving.yaml \
   --filename https://github.com/knative/eventing/releases/download/v0.11.0/release.yaml \
   `#--filename https://github.com/knative/serving/releases/download/v0.11.0/monitoring.yaml`

echo
echo "Uninstalling Istio"
echo "=================="

cd istio-1.4.1

echo
echo "Uninstall Istio using istio-lean.yaml"
echo "-------------------------------------"

kubectl delete -f istio-lean.yaml

echo
echo "Delete istio-system namespace"
echo "-----------------------------"

kubectl delete ns istio-system

cd ..
