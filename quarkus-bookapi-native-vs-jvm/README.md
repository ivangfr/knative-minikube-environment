# knative-minikube-environment
## `> quarkus-bookapi-native-vs-jvm`

The goal of this example is to run in `Knative` cluster an application called `quarkus-book-api` whose source code can be found [here](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot/tree/master/book-api/quarkus-book-api).

`quarkus-book-api`, as its name suggests, is a [`Quarkus`](https://quarkus.io/) Java Web application that exposes a REST API for managing `books`.

We will use two `quarkus-book-api` Docker images: [`quarkus-book-api-jvm`](https://hub.docker.com/r/ivanfranchin/quarkus-book-api-jvm) and [`quarkus-book-api-native`](https://hub.docker.com/r/ivanfranchin/quarkus-book-api-native). The difference between them is that the former was built in order to have a container that runs the application in **JVM mode** and the latter was built in order to have a container that runs the application in **Native mode**.

We will see that `quarkus-book-api-native` has a faster response time than `quarkus-book-api-jvm` as the application inside it was build using [`GraalVM Native Image`](https://www.graalvm.org/docs/reference-manual/native-image/) tool. More about the comparison between `JVM` vs `Native` and among Java Frameworks can be found [here](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot)

## Start Minikube and Install Knative

First of all, start `Minikube` and install `Knative` as explained at [Start Environment](https://github.com/ivangfr/knative-minikube-environment#start-environment) in the main README.

## Start Environment

1. Open a terminal and navigate to `knative-minikube-environment/quarkus-bookapi-native-vs-jvm` folder

1. Let's pull `MySQL` and `quarkus-book-api` applications Docker images so when we install them, their images are already present

   1. Set `Minikube` host
      ```
      eval $(minikube docker-env)
      ```
      
   1. Pull `MySQL` and `quarkus-book-api`'s docker images
      ```
      docker pull mysql:5.7.30
      docker pull ivanfranchin/quarkus-book-api-jvm:1.0.0
      docker pull ivanfranchin/quarkus-book-api-native:1.0.0
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

1. Run the `helm` command below to install `MySQL` using its Helm Chart
   ```
   helm install my-mysql \
   --namespace dev \
   --set imageTag=5.7.30 \
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

1. In a terminal and inside `knative-minikube-environment/quarkus-bookapi-native-vs-jvm` folder, run the following command to install the service
   ```
   kubectl apply --namespace dev -f yaml-files/quarkus-book-api-native-service.yaml
   ```
   > To delete run
   > ```
   > kubectl delete --namespace dev -f yaml-files/quarkus-book-api-native-service.yaml
   > ```

1. You can watch the service installation by running
   ```
   kubectl get pods --namespace dev -w
   ```
   > Press `Ctrl+C` to stop the watching mode

1. To get more details about the service run
   ```
   kubectl describe ksvc --namespace dev quarkus-book-api-native
   ```
   
1. Before continue, verify if the service is ready to receive requests. For it, run
   ```
   kubectl get ksvc --namespace dev
   ```
   
   It must have the value `True` in the column `READY`. If not, wait a bit or check [Troubleshooting](https://github.com/ivangfr/knative-minikube-environment#troubleshooting).
   
1. Make requests to the service
   
   1. Get `Kong` Ingress Gateway IP Address
      ```
      ../get-kong-external-ip-address.sh
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
      
      - Get a specific book
        ```
        curl -i -H "Host: quarkus-book-api-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books/1
        ```

## Install quarkus-book-api-jvm service

1. In a terminal and inside `knative-minikube-environment/quarkus-bookapi-native-vs-jvm` folder, run the following command to install the service
   ```
   kubectl apply --namespace dev -f yaml-files/quarkus-book-api-jvm-service.yaml
   ```
   > To delete run
   > ```
   > kubectl delete --namespace dev -f yaml-files/quarkus-book-api-jvm-service.yaml
   > ```

1. You can watch the service installation by running
   ```
   kubectl get pods --namespace dev -w
   ```
   > Press `Ctrl+C` to stop the watching mode

1. To get more details about the service run
   ```
   kubectl describe ksvc --namespace dev quarkus-book-api-jvm
   ``` 
   
1. Before continue, verify if the service is ready to receive requests. For it, run
   ```
   kubectl get ksvc --namespace dev
   ```
   
   It must have the value `True` in the column `READY`. If not, wait a bit or check [Troubleshooting](https://github.com/ivangfr/knative-minikube-environment#troubleshooting).
   
1. Make requests to the service
   
   1. Get `Kong` Ingress Gateway IP Address
      ```
      ../get-kong-external-ip-address.sh
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
     
      - Get a specific book
        ```
        curl -i -H "Host: quarkus-book-api-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books/2
        ```

## Example of Executions

### quarkus-book-api-native

1. Watching Pods in `dev` namespace. Just `MySQL` is running.
   ```
   $ kubectl get pods -n dev -w
   NAME                        READY   STATUS    RESTARTS   AGE
   my-mysql-58496cd8f8-xnwwd   1/1     Running   0          9m58s
   ```
   
1. Calling get all books. The response was returned in `2778 ms`
   ```
   $ curl -i -H "Host: quarkus-book-api-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
   HTTP/1.1 200 OK
   Content-Type: application/json
   Content-Length: 94
   Connection: keep-alive
   Date: Sun, 05 Jul 2020 14:41:03 GMT
   X-Kong-Upstream-Latency: 2778
   X-Kong-Proxy-Latency: 0
   Via: kong/2.0.4
   
   [{"id":1,"isbn":"123","title":"Learn Knative"},{"id":2,"isbn":"124","title":"Learn Minikube"}]
   ```

1. Watching `quarkus-book-api-native` Pod changing from `ContainerCreating`, `Running` to `Terminating`
   ```
   $ kubectl get pods -n dev -w
   NAME                        READY   STATUS    RESTARTS   AGE
   my-mysql-58496cd8f8-xnwwd   1/1     Running   0          9m58s
   quarkus-book-api-native-4xd9h-deployment-7c8f47fbb4-rx5xx   0/2     Pending   0          0s
   quarkus-book-api-native-4xd9h-deployment-7c8f47fbb4-rx5xx   0/2     Pending   0          0s
   quarkus-book-api-native-4xd9h-deployment-7c8f47fbb4-rx5xx   0/2     ContainerCreating   0          0s
   quarkus-book-api-native-4xd9h-deployment-7c8f47fbb4-rx5xx   1/2     Running             0          2s
   quarkus-book-api-native-4xd9h-deployment-7c8f47fbb4-rx5xx   2/2     Running             0          3s
   quarkus-book-api-native-4xd9h-deployment-7c8f47fbb4-rx5xx   2/2     Terminating         0          64s
   quarkus-book-api-native-4xd9h-deployment-7c8f47fbb4-rx5xx   1/2     Terminating         0          96s
   quarkus-book-api-native-4xd9h-deployment-7c8f47fbb4-rx5xx   0/2     Terminating         0          98s
   quarkus-book-api-native-4xd9h-deployment-7c8f47fbb4-rx5xx   0/2     Terminating         0          110s
   quarkus-book-api-native-4xd9h-deployment-7c8f47fbb4-rx5xx   0/2     Terminating         0          111s
   ```
   
### quarkus-book-api-jvm

1. Watching Pods in `dev` namespace. Just `MySQL` is running.
   ```
   $ kubectl get pods -n dev -w
   NAME                        READY   STATUS    RESTARTS   AGE
   my-mysql-58496cd8f8-xnwwd   1/1     Running   0          13m
   ```
   
1. Calling get all books. The response was returned in `11952 ms`
   ```
   $ curl -i -H "Host: quarkus-book-api-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
   HTTP/1.1 200 OK
   Content-Type: application/json
   Content-Length: 94
   Connection: keep-alive
   Date: Sun, 05 Jul 2020 14:45:27 GMT
   X-Kong-Upstream-Latency: 11952
   X-Kong-Proxy-Latency: 0
   Via: kong/2.0.4
   
   [{"id":1,"isbn":"123","title":"Learn Knative"},{"id":2,"isbn":"124","title":"Learn Minikube"}]
   ```

1. Watching `quarkus-book-api-jvm` Pod changing from `ContainerCreating`, `Running` to `Terminating`
   ```
   $ kubectl get pods -n dev -w
   NAME                        READY   STATUS    RESTARTS   AGE
   my-mysql-58496cd8f8-xnwwd   1/1     Running   0          13m
   quarkus-book-api-jvm-s9mb8-deployment-74d7c6787f-tlbb9   0/2     Pending   0          0s
   quarkus-book-api-jvm-s9mb8-deployment-74d7c6787f-tlbb9   0/2     Pending   0          0s
   quarkus-book-api-jvm-s9mb8-deployment-74d7c6787f-tlbb9   0/2     ContainerCreating   0          1s
   quarkus-book-api-jvm-s9mb8-deployment-74d7c6787f-tlbb9   1/2     Running             0          4s
   quarkus-book-api-jvm-s9mb8-deployment-74d7c6787f-tlbb9   2/2     Running             0          9s
   quarkus-book-api-jvm-s9mb8-deployment-74d7c6787f-tlbb9   2/2     Terminating         0          71s
   quarkus-book-api-jvm-s9mb8-deployment-74d7c6787f-tlbb9   1/2     Terminating         0          102s
   quarkus-book-api-jvm-s9mb8-deployment-74d7c6787f-tlbb9   0/2     Terminating         0          104s
   quarkus-book-api-jvm-s9mb8-deployment-74d7c6787f-tlbb9   0/2     Terminating         0          115s
   quarkus-book-api-jvm-s9mb8-deployment-74d7c6787f-tlbb9   0/2     Terminating         0          115s
   ```

## Native vs JVM Comparison

The comparison times shown in the table below were obtained from the 1st request made to the services

| Service                 | Request        | Response Time |
| ----------------------- | -------------- | ------------- |
| quarkus-book-api-native | GET /api/books |          ~ 3s |
| quarkus-book-api-jvm    | GET /api/books |         ~ 12s |

By saying _1st request_, it means that the time of those requests are the sum of the following times:
- time for the caller's request to reach `Knative` cluster;
- time for `Knative` cluster to up-scale a `Pod` because none was running when the request arrived;
- time for the application (inside the Docker container) to startup, process the request and send back the response;
- time for the caller to receive the response from the network.

Subsequent requests will be handled pretty fast because `Pod`s to handle them are already up and running. After a period of inactivity, `Knative` cluster will terminate those `Pod`s, down-scaling them to `0`.

From the results above, as both `quarkus-book-api-native` and `quarkus-book-api-jvm` are running on the same environment and under the same conditions, it's clear that the former is better due to its fast application's startup (less than `100ms`) and processing time.

## Cleanup

- In a terminal, make sure you are inside `knative-minikube-environment/quarkus-bookapi-native-vs-jvm` folder

- Run the following script to uninstall everything installed in this example
  ```
  ./cleanup.sh
  ```
