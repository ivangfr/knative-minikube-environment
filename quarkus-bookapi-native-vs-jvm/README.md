# `knative-minikube-environment`
## `> quarkus-bookapi-native-vs-jvm`

The goal of this example is to run in `Knative` cluster an application called `quarkus-book-api` whose source code can be found [here](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot/tree/master/book-api/quarkus-book-api).

`quarkus-book-api`, as its name suggests, is a [`Quarkus`](https://quarkus.io/) Java Web application that exposes a REST API for managing `books`.

We will use two `quarkus-book-api` Docker images: [`quarkus-book-api-jvm`](https://hub.docker.com/r/ivanfranchin/quarkus-book-api-jvm) and [`quarkus-book-api-native`](https://hub.docker.com/r/ivanfranchin/quarkus-book-api-native). The difference between them is that the former was built in order to have a container that runs the application in **JVM mode** and the latter was built in order to have a container that runs the application in **Native mode**.

We will see that `quarkus-book-api-native` has a faster response time than `quarkus-book-api-jvm` as the application inside it was build using [`GraalVM Native Image`](https://www.graalvm.org/docs/reference-manual/native-image/) tool. More about the comparison between `JVM` vs `Native` and among Java Frameworks can be found [here](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot)

## Start Minikube and Install Knative

First of all, start `Minikube` and install `Knative` as explained at [Start Environment](https://github.com/ivangfr/knative-minikube-environment#start-environment) in the main README.

## Start Environment

1. Open a terminal and navigate to `knative-minikube-environment/quarkus-bookapi-native-vs-jvm`

1. Create the `dev` namespace 
   ```
   kubectl create namespace dev
   ```
   > To delete run
   > ```
   > kubectl delete namespace dev
   > ```

1. Run the `helm` command below to install `MySQL` using its Helm Chart
   ```
   helm install my-mysql \
   --namespace dev \
   --set imageTag=5.7.28 \
   --set mysqlDatabase=bookdb \
   --set mysqlRootPassword=secret \
   --set persistence.enabled=false \
   stable/mysql
   ```
   > To delete run
   > ```
   > helm delete --namespace dev my-mysql
   > ```

## Install quarkus-book-api-native Service

1. In a terminal and inside `knative-minikube-environment/quarkus-bookapi-native-vs-jvm`, run the following command to install the service
   ```
   kubectl apply --namespace dev -f yaml-files/quarkus-book-api-native-service.yaml
   ```
   > To delete run
   > ```
   > kubectl delete --namespace dev -f yaml-files/quarkus-book-api-native-service.yaml
   > ```

1. To get more details about the service run
   ```
   kubectl describe ksvc --namespace dev quarkus-book-api-native
   ```
   
1. To find the URL of the services run
   ```
   kubectl get ksvc --namespace dev
   ```
   > **Note:** Before continue, verify if the service has value `True` in the column `READY`. Check [Troubleshooting](https://github.com/ivangfr/knative-minikube-environment#troubleshooting) in case it's `False`.
   
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

   1. Sample of requests
   
      - Get all books
        ```
        curl -i -H "Host: quarkus-book-api-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
        ```
        
      - Add a book
        ```
        curl -i -H "Host: quarkus-book-api-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books \
        -H "Content-Type: application/json" -d '{ "isbn": 123, "title": "Learn Knative" }'
        ```
      
      - Add a specific book
        ```
        curl -i -H "Host: quarkus-book-api-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books/1
        ```

## Install quarkus-book-api-jvm service

1. In a terminal and inside `knative-minikube-environment/quarkus-bookapi-native-vs-jvm`, run the following command to install the service
   ```
   kubectl apply --namespace dev -f yaml-files/quarkus-book-api-jvm-service.yaml
   ```
   > To delete run
   > ```
   > kubectl delete --namespace dev -f yaml-files/quarkus-book-api-jvm-service.yaml
   > ```
   
1. To get more details about the service run
   ```
   kubectl describe ksvc --namespace dev quarkus-book-api-jvm
   ``` 
   
1. To find the URL of the services run
   ```
   kubectl get ksvc --namespace dev
   ```
   > **Note:** Before continue, verify if the service has value `True` in the column `READY`. Check [Troubleshooting](https://github.com/ivangfr/knative-minikube-environment#troubleshooting) in case it's `False`.
   
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

   1. Sample of requests
      
      - Get all books
        ```
        curl -i -H "Host: quarkus-book-api-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
        ```
       
      - Add a book
        ```
        curl -i -H "Host: quarkus-book-api-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books \
        -H "Content-Type: application/json" -d '{ "isbn": 124, "title": "Learn Minikube" }'
        ```
     
      - Add a specific book
        ```
        curl -i -H "Host: quarkus-book-api-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books/2
        ```

## Example of Executions

### quarkus-book-api-native

1. Watching Pods in `dev` namespace. Just `MySQL` is running.
   ```
   $ kubectl get pods -n dev -w
   NAME                        READY   STATUS    RESTARTS   AGE
   my-mysql-7d56d9995d-gwrjk   1/1     Running   0          47m
   ```
   
1. Calling get all books. The response was returned in `5811 ms`
   ```
   $ curl -i -H "Host: quarkus-book-api-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
   HTTP/1.1 200 OK
   content-length: 2
   content-type: application/json
   date: Mon, 23 Dec 2019 14:12:50 GMT
   x-envoy-upstream-service-time: 5811
   server: istio-envoy
   
   []
   ```

1. Watching `quarkus-book-api-native` Pod changing from `ContainerCreating`, `Running` to `Terminating`
   ```
   $ kubectl get pods -n dev -w
   NAME                        READY   STATUS    RESTARTS   AGE
   my-mysql-7d56d9995d-gwrjk   1/1     Running   0          47m
   quarkus-book-api-native-ztxw9-deployment-6d6b5d45c5-7548f   0/2     Pending   0          0s
   quarkus-book-api-native-ztxw9-deployment-6d6b5d45c5-7548f   0/2     Pending   0          0s
   quarkus-book-api-native-ztxw9-deployment-6d6b5d45c5-7548f   0/2     ContainerCreating   0          0s
   quarkus-book-api-native-ztxw9-deployment-6d6b5d45c5-7548f   1/2     Running             0          5s
   quarkus-book-api-native-ztxw9-deployment-6d6b5d45c5-7548f   2/2     Running             0          5s
   quarkus-book-api-native-ztxw9-deployment-6d6b5d45c5-7548f   2/2     Terminating         0          67s
   quarkus-book-api-native-ztxw9-deployment-6d6b5d45c5-7548f   1/2     Terminating         0          89s
   quarkus-book-api-native-ztxw9-deployment-6d6b5d45c5-7548f   0/2     Terminating         0          91s
   quarkus-book-api-native-ztxw9-deployment-6d6b5d45c5-7548f   0/2     Terminating         0          94s
   quarkus-book-api-native-ztxw9-deployment-6d6b5d45c5-7548f   0/2     Terminating         0          95s
   ```
   
### quarkus-book-api-jvm

1. Watching Pods in `dev` namespace. Just `MySQL` is running.
   ```
   $ kubectl get pods -n dev -w
   NAME                        READY   STATUS    RESTARTS   AGE
   my-mysql-7d56d9995d-gwrjk   1/1     Running   0          67m
   ```
   
1. Calling get all books. The response was returned in `14109 ms`
   ```
   $ curl -i -H "Host: quarkus-book-api-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
   HTTP/1.1 200 OK
   content-length: 2
   content-type: application/json
   date: Mon, 23 Dec 2019 14:26:44 GMT
   x-envoy-upstream-service-time: 14109
   server: istio-envoy
   
   []
   ```

1. Watching `quarkus-book-api-jvm` Pod changing from `ContainerCreating`, `Running` to `Terminating`
   ```
   $ kubectl get pods -n dev -w
   NAME                        READY   STATUS    RESTARTS   AGE
   my-mysql-7d56d9995d-gwrjk   1/1     Running   0          67m
   quarkus-book-api-jvm-mrhqp-deployment-6c7d87554c-9nfsg   0/2     Pending   0          0s
   quarkus-book-api-jvm-mrhqp-deployment-6c7d87554c-9nfsg   0/2     Pending   0          0s
   quarkus-book-api-jvm-mrhqp-deployment-6c7d87554c-9nfsg   0/2     ContainerCreating   0          0s
   quarkus-book-api-jvm-mrhqp-deployment-6c7d87554c-9nfsg   1/2     Running             0          4s
   quarkus-book-api-jvm-mrhqp-deployment-6c7d87554c-9nfsg   2/2     Running             0          11s
   quarkus-book-api-jvm-mrhqp-deployment-6c7d87554c-9nfsg   2/2     Terminating         0          73s
   quarkus-book-api-jvm-mrhqp-deployment-6c7d87554c-9nfsg   1/2     Terminating         0          95s
   quarkus-book-api-jvm-mrhqp-deployment-6c7d87554c-9nfsg   0/2     Terminating         0          97s
   quarkus-book-api-jvm-mrhqp-deployment-6c7d87554c-9nfsg   0/2     Terminating         0          98s
   quarkus-book-api-jvm-mrhqp-deployment-6c7d87554c-9nfsg   0/2     Terminating         0          98s
   ```

## Native vs JVM Comparison

The comparison times shown in the table below were obtained from the 1st request made to the services

| Service                 | Request        | Response Time |
| ----------------------- | -------------- | ------------- |
| quarkus-book-api-native | GET /api/books |          ~ 6s |
| quarkus-book-api-jvm    | GET /api/books |         ~ 15s |

By saying _1st request_, it means that the time of those requests are the sum of the following times:
- time for the caller's request to reach `Knative` cluster;
- time for `Knative` cluster to up-scale a `Pod` because none was running when the request arrived;
- time for the application (inside the Docker container) to startup, process the request and send back the response;
- time for the caller to receive the response from the network.

Subsequents requests will be handled pretty fast because `Pod`s to handle them are already up and running. After a period of inactivity, `Knative` cluster will terminate those `Pod`s, down-scaling them to `0`.

From the results above, as both `quarkus-book-api-native` and `quarkus-book-api-jvm` are running on the same environment and under the same conditions, it's clear that the former is better due to its fast application's startup (less than `100ms`) and processing time.

## Cleanup

Run the following script to uninstall everything installed in this example
```
./cleanup.sh
```
