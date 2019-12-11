#!/usr/bin/env bash

echo
echo "Uninstalling Ambassador"
echo "======================="

kubectl delete \
  --filename https://getambassador.io/yaml/ambassador/ambassador-knative.yaml \
  --filename https://getambassador.io/yaml/ambassador/ambassador-service.yaml

echo
echo "Uninstalling Knative"
echo "===================="

kubectl delete --filename https://github.com/knative/serving/releases/download/v0.10.0/serving-core.yaml