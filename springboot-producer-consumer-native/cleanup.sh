#!/usr/bin/env bash

kubectl delete --namespace dev --filename yaml-files/springboot-kafka-consumer-native-service.yaml
kubectl delete --namespace dev --filename yaml-files/springboot-kafka-producer-native-service.yaml

kubectl delete namespace dev
