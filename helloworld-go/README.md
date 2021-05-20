# knative-minikube-environment
## `> helloworld-go`

The goal of this example is to run in `Knative` cluster the [`helloworld-go`](https://knative.dev/docs/serving/samples/hello-world/helloworld-go/index.html)

## Start Minikube and install Knative

First of all, start `Minikube` and install `Knative` as explained at [Start Environment](https://github.com/ivangfr/knative-minikube-environment#start-environment) in the main README.

## Install helloworld-go Service

1. Open a terminal and navigate to `knative-minikube-environment/helloworld-go` folder

1. Let's pull `helloworld-go` Docker image so, when we install the service, the image is already present

   1. Set `Minikube` host
      ```
      eval $(minikube docker-env)
      ```
      
   1. Pull `helloworld-go` docker image
      ```
      docker pull gcr.io/knative-samples/helloworld-go
      ```
      
   1. Get back to Host machine Docker Daemon
      ```
      eval $(minikube docker-env -u)
      ```

1. Create the `dev` namespace 
   ```
   kubectl create namespace dev
   ```
   > To delete run
   > ```
   > kubectl delete namespace dev
   > ```

1. Install `helloworld-go` service by running the following `kubectl apply` command
   ```
   kubectl apply --namespace dev -f helloworld-go-service.yaml
   ```
   > To delete run
   > ```
   > kubectl delete --namespace dev -f helloworld-go-service.yaml
   > ```

1. You can watch the service installation by running
   ```
   kubectl get pods --namespace dev -w
   ```
   > Press `Ctrl+C` to stop the watching mode

1. Check whether the service was installed correctly by running
   ```
   kubectl describe --namespace dev ksvc helloworld-go
   ```

1. Before continue, verify if the service is ready to receive requests
   ```
   kubectl get ksvc --namespace dev
   ```
   
   It must have the value `True` in the column `READY`. If not, wait a bit or check [Troubleshooting](https://github.com/ivangfr/knative-minikube-environment#troubleshooting).

1. Make requests to the service
   
   1. Get `Kong` Ingress Gateway IP Address
      ```
      ../get-kong-external-ip-address.sh
      ```
        
   1. Set the `EXTERNAL_IP_ADDRESS` environment variable in a terminal
      ```
      EXTERNAL_IP_ADDRESS=...
      ``` 

   1. Call endpoint using `curl`
      ```
      curl -i -H "Host: helloworld-go.dev.example.com" http://$EXTERNAL_IP_ADDRESS
      ```
      
   1. Start watching the pods in `dev` namespace
      ```
      kubectl get pods -n dev -w
      ```
      And wait a bit without making any requests, you will see that kubernetes will scale to `0` the number of `helloworld-go` pods

## Cleanup

- In a terminal, make sure you are inside `knative-minikube-environment/helloworld-go` folder

- Run the following script to uninstall `helloworld-go` Service and delete `dev` namespace
  ```
  ./cleanup.sh
  ```
