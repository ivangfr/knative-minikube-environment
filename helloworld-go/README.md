# `knative-minukube-environment`
## `> helloworld-go`

The goal of this example is to run in `Knative` cluster the [`helloworld-go`](https://knative.dev/docs/serving/samples/hello-world/helloworld-go/index.html)

## Start Minikube and install Knative

First of all, start `Minikube` and install `Knative` as explained at [Start Environment](https://github.com/ivangfr/knative-minikube-environment#start-environment) in the main README.

## Install helloworld-go Service

1. Open a terminal and navigate to `knative-minukube-environment/helloworld-go`

1. Install `helloworld-go` service by running the following `kubectl apply` command
   ```
   kubectl apply -f helloworld-go-service.yaml
   ```

1. Check whether the service was installed correctly by running
   ```
   kubectl describe ksvc helloworld-go
   ```

1. To find the URL of the service run
   ```
   kubectl get ksvc helloworld-go
   ```
   > **Note:** Before continue, verify if the service has value `True` in the column `READY`. Check [Troubleshooting](https://github.com/ivangfr/knative-minikube-environment#shutdown-minikube) in case it's `False`.

1. Make requests to the service
   
   1. Get the Ingress Gateway IP Address

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

## Uninstall helloworld-go Service

To uninstall, run the following command
```
kubectl delete -f helloworld-go-service.yaml
```
