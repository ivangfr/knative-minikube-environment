#!/usr/bin/env bash

echo
echo "Uninstalling Knative Eventing"
echo "============================="

kubectl delete --filename https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/knative-v1.3.2/eventing-kafka-broker.yaml

kubectl delete --filename https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/knative-v1.3.2/eventing-kafka-controller.yaml

kubectl delete --filename https://storage.googleapis.com/knative-nightly/eventing-kafka/latest/channel-distributed.yaml
kubectl delete --filename https://storage.googleapis.com/knative-nightly/eventing-kafka/latest/channel-consolidated.yaml
kubectl delete --filename https://storage.googleapis.com/knative-nightly/eventing-kafka/latest/source.yaml

kubectl delete --namespace kafka --filename https://strimzi.io/examples/latest/kafka/kafka-persistent-single.yaml
kubectl delete --namespace kafka --filename https://strimzi.io/install/latest?namespace=kafka
kubectl delete namespace kafka

kubectl delete --filename https://github.com/knative/eventing/releases/download/knative-v1.3.2/eventing-core.yaml
kubectl delete --filename https://github.com/knative/eventing/releases/download/knative-v1.3.2/eventing-crds.yaml
