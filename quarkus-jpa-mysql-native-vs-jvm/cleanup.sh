#!/usr/bin/env bash

kubectl delete --namespace dev --filename yaml-files/quarkus-jpa-mysql-native-service.yaml
kubectl delete --namespace dev --filename yaml-files/quarkus-jpa-mysql-jvm-service.yaml

helm delete --namespace dev my-mysql

kubectl delete namespace dev
