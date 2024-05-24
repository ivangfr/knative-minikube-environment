#!/usr/bin/env bash

echo
echo "Uninstalling Knative Eventing"
echo "============================="

kubectl delete --filename https://github.com/knative-extensions/eventing-kafka-broker/releases/download/knative-v1.14.3/eventing-kafka-controller.yaml
kubectl delete --filename https://github.com/knative-extensions/eventing-kafka-broker/releases/download/knative-v1.14.3/eventing-kafka-source.yaml

kubectl delete --namespace kafka --filename https://strimzi.io/examples/latest/kafka/kafka-persistent-single.yaml
kubectl delete --namespace kafka --filename https://strimzi.io/install/latest?namespace=kafka
kubectl delete namespace kafka

kubectl delete --filename https://github.com/knative/eventing/releases/download/knative-v1.14.1/eventing-core.yaml
kubectl delete --filename https://github.com/knative/eventing/releases/download/knative-v1.14.1/eventing-crds.yaml
