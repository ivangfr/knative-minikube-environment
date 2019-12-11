#!/usr/bin/env bash

echo
echo "Uninstalling Knative"
echo "===================="

# Note: The file `monitoring.yaml` is not added because it is failing, [Issue 6073](https://github.com/knative/serving/issues/6073)

kubectl delete \
   --filename https://github.com/knative/serving/releases/download/v0.10.0/serving.yaml \
   --filename https://github.com/knative/eventing/releases/download/v0.10.0/release.yaml \
   `# --filename https://github.com/knative/serving/releases/download/v0.10.0/monitoring.yaml`

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
