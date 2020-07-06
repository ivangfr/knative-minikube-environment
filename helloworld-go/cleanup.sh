#!/usr/bin/env bash

kubectl delete --namespace dev -f helloworld-go-service.yaml

kubectl delete namespace dev
