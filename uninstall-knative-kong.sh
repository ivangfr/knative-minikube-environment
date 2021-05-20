#!/usr/bin/env bash

echo
echo "Uninstalling Knative & Kong"
echo "==========================="

kubectl delete --filename https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/0.9.x/deploy/single/all-in-one-dbless.yaml

kubectl delete --filename https://storage.googleapis.com/knative-nightly/serving/latest/serving-core.yaml
kubectl delete --filename https://storage.googleapis.com/knative-nightly/serving/latest/serving-crds.yaml
