#!/usr/bin/env bash

kubectl delete --namespace dev -f yaml-files/quarkus-book-api-native-service.yaml
kubectl delete --namespace dev -f yaml-files/quarkus-book-api-jvm-service.yaml

helm delete --namespace dev my-mysql

kubectl delete namespace dev
