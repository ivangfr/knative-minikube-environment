#!/usr/bin/env bash

kubectl delete --namespace dev --filename helloworld-go-service.yaml

kubectl delete namespace dev
