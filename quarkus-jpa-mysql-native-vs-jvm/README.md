# knative-minikube-environment
## `> quarkus-jpa-mysql-native-vs-jvm`

The goal of this example is to run in `Knative` cluster an application called `quarkus-jpa-mysql` whose source code can be found in [ivangfr/graalvm-quarkus-micronaut-springboot](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot/tree/master/jpa-mysql/quarkus-jpa-mysql) repository.

`quarkus-jpa-mysql` is a [`Quarkus`](https://quarkus.io/) Java Web application that exposes a REST API for managing `books`. It uses [`MySQL`](https://www.mysql.com/) as database.

We will run two `quarkus-jpa-mysql` Docker images:
- [`quarkus-jpa-mysql-jvm`](https://hub.docker.com/r/ivanfranchin/quarkus-jpa-mysql-jvm) whose Docker image was in order to have a container that runs the application in **JVM mode**;
- [`quarkus-jpa-mysql-native`](https://hub.docker.com/r/ivanfranchin/quarkus-jpa-mysql-native) whose Docker image built using [`GraalVM Native Image`](https://www.graalvm.org/docs/reference-manual/native-image/) tool in order to have a container that runs the application in **Native mode**.

More about the comparison between `JVM` vs `Native` and among Java Frameworks can be found in [ivangfr/graalvm-quarkus-micronaut-springboot](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot) repository.

## Start Minikube and Install Knative

First, start `Minikube` and install `Knative` as explained at [Start Environment](https://github.com/ivangfr/knative-minikube-environment#start-environment) in the main README.

## Start Environment

1. Open a terminal and navigate to `knative-minikube-environment/quarkus-jpa-mysql-native-vs-jvm` folder

1. Let's pull `MySQL` and `quarkus-jpa-mysql` Docker images so when we install them, their images are already present

   1. Set `Minikube` host
      ```
      eval $(minikube docker-env)
      ```
      
   1. Pull `MySQL` and `quarkus-jpa-mysql`'s docker images
      ```
      docker pull bitnami/mysql:5.7.37-debian-10-r85
      docker pull ivanfranchin/quarkus-jpa-mysql-native:1.0.0
      docker pull ivanfranchin/quarkus-jpa-mysql-jvm:1.0.0
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
     --set image.tag=5.7.37-debian-10-r85 \
     --set auth.rootPassword=secret \
     --set auth.database=bookdb_native \
     --set primary.persistence.enabled=false \
     --set secondary.replicaCount=0 \
     bitnami/mysql
   ```
   > To delete run
   > ```
   > helm delete --namespace dev my-mysql
   > ```

## Install quarkus-jpa-mysql-native Service

1. In a terminal and inside `knative-minikube-environment/quarkus-jpa-mysql-native-vs-jvm` folder, run the following command to install the service
   ```
   kubectl apply --namespace dev --filename yaml-files/quarkus-jpa-mysql-native-service.yaml
   ```
   > To delete run
   > ```
   > kubectl delete --namespace dev --filename yaml-files/quarkus-jpa-mysql-native-service.yaml
   > ```

1. You can watch the service installation by running
   ```
   kubectl get pods --namespace dev --watch
   ```
   > Press `Ctrl+C` to stop the watching mode

1. To get more details about the service run
   ```
   kubectl describe ksvc --namespace dev quarkus-jpa-mysql-native
   ```
   
1. Before continue, verify if the service is ready to receive requests
   ```
   kubectl get ksvc --namespace dev
   ```
   
   It must have the value `True` in the column `READY`. If not, wait a bit or check [Troubleshooting](https://github.com/ivangfr/knative-minikube-environment#troubleshooting).
   
1. Make requests to the service
   
   1. Get `Kourier` Ingress Gateway IP Address
      ```
      ../get-kourier-external-ip-address.sh
      ```

   1. Set the `EXTERNAL_IP_ADDRESS` environment variable in a terminal
      ```
      EXTERNAL_IP_ADDRESS=...
      ``` 

   1. Sample of requests
   
      - Get all books
        ```
        curl -i -H "Host: quarkus-jpa-mysql-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
        ```
        
      - Add a book
        ```
        curl -i -H "Host: quarkus-jpa-mysql-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books \
        -H "Content-Type: application/json" -d '{ "isbn": 123, "title": "Learn Knative" }'
        ```
      
      - Get a specific book
        ```
        curl -i -H "Host: quarkus-jpa-mysql-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books/1
        ```

## Install quarkus-jpa-mysql-jvm service

1. In a terminal and inside `knative-minikube-environment/quarkus-jpa-mysql-native-vs-jvm` folder, run the following command to install the service
   ```
   kubectl apply --namespace dev --filename yaml-files/quarkus-jpa-mysql-jvm-service.yaml
   ```
   > To delete run
   > ```
   > kubectl delete --namespace dev --filename yaml-files/quarkus-jpa-mysql-jvm-service.yaml
   > ```

1. You can watch the service installation by running
   ```
   kubectl get pods --namespace dev --watch
   ```
   > Press `Ctrl+C` to stop the watching mode

1. To get more details about the service run
   ```
   kubectl describe ksvc --namespace dev quarkus-jpa-mysql-jvm
   ``` 
   
1. Before continue, verify if the service is ready to receive requests
   ```
   kubectl get ksvc --namespace dev
   ```
   
   It must have the value `True` in the column `READY`. If not, wait a bit or check [Troubleshooting](https://github.com/ivangfr/knative-minikube-environment#troubleshooting).
   
1. Make requests to the service
   
   1. Get `Kourier` Ingress Gateway IP Address
      ```
      ../get-kourier-external-ip-address.sh
      ```
        
   1. Set the `EXTERNAL_IP_ADDRESS` environment variable in a terminal
      ```
      EXTERNAL_IP_ADDRESS=...
      ``` 

   1. Sample of requests
      
      - Get all books
        ```
        curl -i -H "Host: quarkus-jpa-mysql-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
        ```
       
      - Add a book
        ```
        curl -i -H "Host: quarkus-jpa-mysql-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books \
        -H "Content-Type: application/json" -d '{ "isbn": 124, "title": "Learn Minikube" }'
        ```
     
      - Get a specific book
        ```
        curl -i -H "Host: quarkus-jpa-mysql-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books/2
        ```

## Example of Executions

### quarkus-jpa-mysql-native

1. Watching Pods in `dev` namespace. Just `MySQL` is running.
   ```
   $ kubectl get pods --namespace dev --watch
   
   NAME         READY   STATUS    RESTARTS   AGE
   my-mysql-0   1/1     Running   0          13m
   ```
   
1. Calling get all books. The response was returned in `2778 ms`
   ```
   $ curl -i -H "Host: quarkus-jpa-mysql-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
   
   HTTP/1.1 200 OK
   content-length: 94
   content-type: application/json
   date: Sat, 16 Apr 2022 14:24:34 GMT
   x-envoy-upstream-service-time: 1999
   server: envoy
   
   [{"id":1,"isbn":"123","title":"Learn Knative"},{"id":2,"isbn":"124","title":"Learn Minikube"}]
   ```

1. Watching `quarkus-jpa-mysql-native` Pod changing from `ContainerCreating`, `Running` to `Terminating`
   ```
   $ kubectl get pods --namespace dev --watch
   
   NAME         READY   STATUS    RESTARTS   AGE
   my-mysql-0   1/1     Running   0          13m
   quarkus-jpa-mysql-native-00001-deployment-6bffd467ff-47dhg   0/2     Pending   0          0s
   quarkus-jpa-mysql-native-00001-deployment-6bffd467ff-47dhg   0/2     Pending   0          0s
   quarkus-jpa-mysql-native-00001-deployment-6bffd467ff-47dhg   0/2     ContainerCreating   0          0s
   quarkus-jpa-mysql-native-00001-deployment-6bffd467ff-47dhg   1/2     Running             0          1s
   quarkus-jpa-mysql-native-00001-deployment-6bffd467ff-47dhg   2/2     Running             0          1s
   quarkus-jpa-mysql-native-00001-deployment-6bffd467ff-47dhg   2/2     Terminating         0          63s
   quarkus-jpa-mysql-native-00001-deployment-6bffd467ff-47dhg   0/2     Terminating         0          94s
   quarkus-jpa-mysql-native-00001-deployment-6bffd467ff-47dhg   0/2     Terminating         0          94s
   quarkus-jpa-mysql-native-00001-deployment-6bffd467ff-47dhg   0/2     Terminating         0          94s
   ```
   
### quarkus-jpa-mysql-jvm

1. Watching Pods in `dev` namespace. Just `MySQL` is running.
   ```
   $ kubectl get pods --namespace dev --watch
   
   NAME         READY   STATUS    RESTARTS   AGE
   my-mysql-0   1/1     Running   0          15m
   ```
   
1. Calling get all books. The response was returned in `11952 ms`
   ```
   $ curl -i -H "Host: quarkus-jpa-mysql-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books

   HTTP/1.1 200 OK
   content-length: 94
   content-type: application/json
   date: Sat, 16 Apr 2022 14:27:51 GMT
   x-envoy-upstream-service-time: 3530
   server: envoy
   
   [{"id":1,"isbn":"123","title":"Learn Knative"},{"id":2,"isbn":"124","title":"Learn Minikube"}]
   ```

1. Watching `quarkus-jpa-mysql-jvm` Pod changing from `ContainerCreating`, `Running` to `Terminating`
   ```
   $ kubectl get pods --namespace dev --watch

   NAME         READY   STATUS    RESTARTS   AGE
   my-mysql-0   1/1     Running   0          15m
   quarkus-jpa-mysql-jvm-00001-deployment-7f98d4d6d4-p5x5b   0/2     Pending   0          0s
   quarkus-jpa-mysql-jvm-00001-deployment-7f98d4d6d4-p5x5b   0/2     Pending   0          0s
   quarkus-jpa-mysql-jvm-00001-deployment-7f98d4d6d4-p5x5b   0/2     ContainerCreating   0          0s
   quarkus-jpa-mysql-jvm-00001-deployment-7f98d4d6d4-p5x5b   1/2     Running             0          2s
   quarkus-jpa-mysql-jvm-00001-deployment-7f98d4d6d4-p5x5b   2/2     Running             0          3s
   quarkus-jpa-mysql-jvm-00001-deployment-7f98d4d6d4-p5x5b   2/2     Terminating         0          66s
   quarkus-jpa-mysql-jvm-00001-deployment-7f98d4d6d4-p5x5b   0/2     Terminating         0          98s
   quarkus-jpa-mysql-jvm-00001-deployment-7f98d4d6d4-p5x5b   0/2     Terminating         0          98s
   quarkus-jpa-mysql-jvm-00001-deployment-7f98d4d6d4-p5x5b   0/2     Terminating         0          98s
   ```

## Native vs JVM Comparison

The `Response Time` present in the comparison table below was obtained from the 1st request made to the services

| Service                  | Request        | Response Time | App startup |
|--------------------------|----------------|---------------|-------------|
| quarkus-jpa-mysql-native | GET /api/books | 1999 ms       | 37 ms       |
| quarkus-jpa-mysql-jvm    | GET /api/books | 3530 ms       | 1753 ms     |

By saying _1st request_, it means that the `Response Time` has included in it the sum of the following times:
- time for the caller's request to reach `Knative` cluster;
- time for `Knative` cluster to up-scale a `Pod` because none was running when the request arrived;
- time for the application (inside the Docker container) to startup, process the request and send back the response;
- time for the caller to receive the response from the network.

Subsequent requests will be handled pretty fast because the `Pod`s responsible to handle them are already up and running. After a period of inactivity, `Knative` cluster will terminate those `Pod`s, down-scaling them to `0`.

## Cleanup

- In a terminal, make sure you are inside `knative-minikube-environment/quarkus-jpa-mysql-native-vs-jvm` folder

- Run the following script to uninstall everything installed in this example
  ```
  ./cleanup.sh
  ```
