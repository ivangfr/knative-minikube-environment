#!/usr/bin/env bash

kubectl delete --namespace dev --filename yaml-files/springboot-consumer-api-native-service.yaml
kubectl delete --namespace dev --filename yaml-files/springboot-producer-api-native-service.yaml

kubectl delete namespace dev
