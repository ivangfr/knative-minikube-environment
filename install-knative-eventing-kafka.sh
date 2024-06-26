#!/usr/bin/env bash

# This script was implemented based on the Knative Official Documentation (v1.14): https://knative.dev/docs/install/yaml-install/eventing/install-eventing-with-yaml/ and https://knative.dev/docs/eventing/sources/kafka-source/

echo
echo "Installing Knative Eventing using YAML files"
echo "============================================"

echo
echo "Install Knative Eventing"
echo "------------------------"

echo
echo "Install the required custom resource definitions (CRDs)"
echo "-------------------------------------------------------"

kubectl apply --filename https://github.com/knative/eventing/releases/download/knative-v1.14.1/eventing-crds.yaml

echo
echo "Install the core components of Eventing"
echo "---------------------------------------"

kubectl apply --filename https://github.com/knative/eventing/releases/download/knative-v1.14.1/eventing-core.yaml

echo
echo "Install Strimzi"
echo "==============="

kubectl create namespace kafka
kubectl create --namespace kafka --filename https://strimzi.io/install/latest?namespace=kafka
kubectl apply --namespace kafka --filename https://strimzi.io/examples/latest/kafka/kafka-persistent-single.yaml
kubectl wait --namespace kafka kafka/my-cluster --for=condition=Ready --timeout=300s

echo
echo "Install the KafkaSource controller"
echo "=================================="

kubectl apply --filename https://github.com/knative-extensions/eventing-kafka-broker/releases/download/knative-v1.14.3/eventing-kafka-controller.yaml
kubectl apply --filename https://github.com/knative-extensions/eventing-kafka-broker/releases/download/knative-v1.14.3/eventing-kafka-source.yaml

echo
echo "Knative Eventing setup completed successfully"
echo "============================================="
echo
echo "To watch Readiness and Status of all pods (Ctrl+C to stop) : kubectl get pods --all-namespaces --watch"
echo
