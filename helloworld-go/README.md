# `knative-minukube-environment`
## `> helloworld-go`

The goal of this example is to run in Knative cluster the well-known [`helloworld-go`](https://knative.dev/docs/serving/samples/hello-world/helloworld-go/index.html)

## Start Minikube & Knative

First of all, start `Minikube` and `Knative` as explained at [Start Environment](https://github.com/ivangfr/knative-minikube-environment#start-environment)

## Install helloworld-go

1. Open a terminal and navigate to `knative-minukube-environment/helloworld-go`

1. Install `helloworld-go` service by running the following `kubectl apply` command
   ```
   kubectl apply -f helloworld-go-service.yaml
   ```

1. To find the URL of the service run
   ```
   kubectl get ksvc helloworld-go
   ```

1. Make a request to the service
   
   1. Get Ingress Gateway IP Address

      - If you are using `Istio` run
        ```
        ../get-istio-external-ip-address.sh
        ```
     
   	  - If you are using `Ambassador` run
        ```
        ../get-ambassador-external-ip-address.sh
        ```
   1. Export the output to a terminal
      ```
      export EXTERNAL_IP_ADDRESS=...
      ``` 

   1. Call endpoint using `curl`
      ```
      curl -i -H "Host: helloworld-go.default.example.com" http://$EXTERNAL_IP_ADDRESS
      ```
## Uninstall helloworld-go

To uninstall, run the following command
```
kubectl delete -f helloworld-go-service.yaml
```
