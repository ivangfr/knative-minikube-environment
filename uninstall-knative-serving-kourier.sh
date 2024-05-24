#!/usr/bin/env bash

echo
echo "Uninstalling Knative Serving"
echo "============================"

kubectl delete --filename https://github.com/knative/net-kourier/releases/download/knative-v1.14.0/kourier.yaml

kubectl delete --filename https://github.com/knative/serving/releases/download/knative-v1.14.0/serving-core.yaml
kubectl delete --filename https://github.com/knative/serving/releases/download/knative-v1.14.0/serving-crds.yaml
