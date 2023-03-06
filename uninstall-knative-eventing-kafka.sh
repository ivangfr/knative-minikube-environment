#!/usr/bin/env bash

echo
echo "Uninstalling Knative Eventing"
echo "============================="

kubectl apply -f https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/knative-v1.9.3/eventing-kafka-source.yaml
kubectl delete --filename https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/knative-v1.9.3/eventing-kafka-controller.yaml

kubectl delete --namespace kafka --filename https://strimzi.io/examples/latest/kafka/kafka-persistent-single.yaml
kubectl delete --namespace kafka --filename https://strimzi.io/install/latest?namespace=kafka
kubectl delete namespace kafka

kubectl delete --filename https://github.com/knative/eventing/releases/download/knative-v1.9.6/eventing-core.yaml
kubectl delete --filename https://github.com/knative/eventing/releases/download/knative-v1.9.6/eventing-crds.yaml
