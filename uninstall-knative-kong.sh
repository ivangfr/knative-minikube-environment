#!/usr/bin/env bash

echo
echo "Uninstalling Knative & Kong"
echo "==========================="

kubectl delete --filename https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/0.9.x/deploy/single/all-in-one-dbless.yaml

kubectl delete --filename https://github.com/knative/serving/releases/download/v0.15.0/serving-core.yaml