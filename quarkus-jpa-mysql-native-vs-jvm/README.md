# knative-minikube-environment
## `> quarkus-jpa-mysql-native-vs-jvm`

The goal of this example is to run in `Knative` cluster an application called `quarkus-jpa-mysql` whose source code can be found in the [ivangfr/graalvm-quarkus-micronaut-springboot](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot/tree/master/jpa-mysql/quarkus-jpa-mysql) repository.

`quarkus-jpa-mysql` is a [`Quarkus`](https://quarkus.io/) Java Web application that exposes a REST API for managing `books`. It uses [`MySQL`](https://www.mysql.com/) as database.

We will run two `quarkus-jpa-mysql` Docker images:
- [`quarkus-jpa-mysql-jvm`](https://hub.docker.com/r/ivanfranchin/quarkus-jpa-mysql-jvm) whose Docker image was built in order to have a container that runs the application in **JVM mode**;
- [`quarkus-jpa-mysql-native`](https://hub.docker.com/r/ivanfranchin/quarkus-jpa-mysql-native) whose Docker image built using [`GraalVM Native Image`](https://www.graalvm.org/docs/reference-manual/native-image/) tool in order to have a container that runs the application in **Native mode**.

More about the comparison between `JVM` vs `Native` and among Java Frameworks can be found in [ivangfr/graalvm-quarkus-micronaut-springboot](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot) repository.

## Start Minikube and Install Knative

First, start `Minikube` and install `Knative` as explained at [Start Environment](https://github.com/ivangfr/knative-minikube-environment#start-environment) in the main README.

## Start Environment

1. Open a terminal and navigate to `knative-minikube-environment/quarkus-jpa-mysql-native-vs-jvm` folder

2. Let's pull `MySQL` and `quarkus-jpa-mysql` Docker images

   1. Set `Minikube` host:
      ```
      eval $(minikube docker-env)
      ```
      
   2. Pull the following Docker images:
      ```
      docker pull bitnami/mysql:5.7.43-debian-11-r73
      docker pull ivanfranchin/quarkus-jpa-mysql-native:latest
      docker pull ivanfranchin/quarkus-jpa-mysql-jvm:latest
      ```
      
   3. Get back to Host machine Docker Daemon:
      ```
      eval $(minikube docker-env -u)
      ```

3. Create the `dev` namespace:
   ```
   kubectl create namespace dev
   ```
   > To delete run:
   > ```
   > kubectl delete namespace dev
   > ```

4. Run the `helm` command below to install `MySQL` using its Helm Chart:
   ```
   helm install my-mysql \
     --namespace dev \
     --set image.tag=5.7.43-debian-11-r73 \
     --set auth.rootPassword=secret \
     --set auth.database=bookdb_native \
     --set primary.persistence.enabled=false \
     --set secondary.replicaCount=0 \
     bitnami/mysql
   ```
   > To delete run:
   > ```
   > helm delete --namespace dev my-mysql
   > ```

## Install quarkus-jpa-mysql services

1. In a terminal and inside `knative-minikube-environment/quarkus-jpa-mysql-native-vs-jvm` folder, run the following command to install the service:
   ```
   kubectl apply --namespace dev --filename yaml-files/quarkus-jpa-mysql-native-service.yaml
   kubectl apply --namespace dev --filename yaml-files/quarkus-jpa-mysql-jvm-service.yaml
   ```
   > To delete run:
   > ```
   > kubectl delete --namespace dev --filename yaml-files/quarkus-jpa-mysql-native-service.yaml
   > kubectl delete --namespace dev --filename yaml-files/quarkus-jpa-mysql-jvm-service.yaml
   > ```

2. You can watch the installation of the services by running:
   ```
   kubectl get pods --namespace dev --watch
   ```
   > Press `Ctrl+C` to stop the watching mode.

3. To get more details about the services run:
   ```
   kubectl describe ksvc --namespace dev quarkus-jpa-mysql-native
   kubectl describe ksvc --namespace dev quarkus-jpa-mysql-jvm
   ```
   
4. Before continue, verify if the services are ready to receive requests:
   ```
   kubectl get ksvc --namespace dev
   ```
   
   It must have the value `True` in the column `READY`. If not, wait a bit or check [Troubleshooting](https://github.com/ivangfr/knative-minikube-environment#troubleshooting).
   ```
   NAME                               URL                                                       LATESTCREATED                            LATESTREADY                              READY   REASON
   springboot-kafka-consumer-native   http://springboot-kafka-consumer-native.dev.example.com   springboot-kafka-consumer-native-00001   springboot-kafka-consumer-native-00001   True
   springboot-kafka-producer-native   http://springboot-kafka-producer-native.dev.example.com   springboot-kafka-producer-native-00001   springboot-kafka-producer-native-00001   True
   ```
   
5. Make requests to the service
   
   1. Get `Kourier` Ingress Gateway IP Address:
      ```
      ../get-kourier-external-ip-address.sh
      ```

   2. Set the `EXTERNAL_IP_ADDRESS` environment variable in a terminal:
      ```
      EXTERNAL_IP_ADDRESS=...
      ``` 

   3. Sample of requests
   
      - Get all books
        ```
        curl -i -H "Host: quarkus-jpa-mysql-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
        curl -i -H "Host: quarkus-jpa-mysql-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
        ```
        
      - Add a book
        ```
        curl -i -H "Host: quarkus-jpa-mysql-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books \
          -H "Content-Type: application/json" -d '{"isbn": 123, "title": "Learn Knative"}'
        curl -i -H "Host: quarkus-jpa-mysql-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books \
          -H "Content-Type: application/json" -d '{"isbn": 124, "title": "Learn Minikube"}'
        ```
      
      - Get a specific book
        ```
        curl -i -H "Host: quarkus-jpa-mysql-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books/1
        curl -i -H "Host: quarkus-jpa-mysql-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books/2
        ```

## Example of Executions

### quarkus-jpa-mysql-native

1. In a terminal, start watching the Pods in `dev` namespace.
   ```
   kubectl get pods --namespace dev --watch
   ```

   In my case, just `MySQL` is running.
   ```
   NAME         READY   STATUS    RESTARTS   AGE
   my-mysql-0   1/1     Running   0          6m19s
   ```
   
2. In another terminal, run the `curl` command below to get all books.
   ```
   curl -i -H "Host: quarkus-jpa-mysql-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
   ```

   It should return something like:
   ```
   HTTP/1.1 200 OK
   content-length: 98
   content-type: application/json
   date: Sun, 05 Mar 2023 16:55:46 GMT
   x-envoy-upstream-service-time: 2349
   server: envoy
   
   [{"id":"1","isbn":"123","title":"Learn Knative"},{"id":"2","isbn":"124","title":"Learn Minikube"}]
   ```
   In this example, the response was returned in `2349 ms`.

3. In the first terminal, watch `quarkus-jpa-mysql-native` Pod changing from `ContainerCreating`, `Running` to `Terminating`:
   ```
   NAME         READY   STATUS    RESTARTS   AGE
   my-mysql-0   1/1     Running   0          6m19s
   quarkus-jpa-mysql-native-00001-deployment-75b6669784-bl22f   0/2     Pending   0          0s
   quarkus-jpa-mysql-native-00001-deployment-75b6669784-bl22f   0/2     Pending   0          0s
   quarkus-jpa-mysql-native-00001-deployment-75b6669784-bl22f   0/2     ContainerCreating   0          0s
   quarkus-jpa-mysql-native-00001-deployment-75b6669784-bl22f   1/2     Running             0          2s
   quarkus-jpa-mysql-native-00001-deployment-75b6669784-bl22f   2/2     Running             0          2s
   quarkus-jpa-mysql-native-00001-deployment-75b6669784-bl22f   2/2     Terminating         0          64s
   quarkus-jpa-mysql-native-00001-deployment-75b6669784-bl22f   1/2     Terminating         0          90s
   quarkus-jpa-mysql-native-00001-deployment-75b6669784-bl22f   0/2     Terminating         0          94s
   quarkus-jpa-mysql-native-00001-deployment-75b6669784-bl22f   0/2     Terminating         0          94s
   quarkus-jpa-mysql-native-00001-deployment-75b6669784-bl22f   0/2     Terminating         0          94s
   ```
   
### quarkus-jpa-mysql-jvm

1. In a terminal, start watching the Pods in `dev` namespace.
   ```
   kubectl get pods --namespace dev --watch
   ```

   In my case, just `MySQL` is running.
   ```
   NAME         READY   STATUS    RESTARTS   AGE
   my-mysql-0   1/1     Running   0          9m21s
   ```

2. In another terminal, run the `curl` command below to get all books.
   ```
   curl -i -H "Host: quarkus-jpa-mysql-jvm.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/books
   ```

   It should return something like:
   ```
   HTTP/1.1 200 OK
   content-length: 98
   content-type: application/json
   date: Sun, 05 Mar 2023 16:58:54 GMT
   x-envoy-upstream-service-time: 5084
   server: envoy
   
   [{"id":"1","isbn":"123","title":"Learn Knative"},{"id":"2","isbn":"124","title":"Learn Minikube"}]
   ```
   In this example, the response was returned in `5084 ms`

3. In the first terminal, watch `quarkus-jpa-mysql-jvm` Pod changing from `ContainerCreating`, `Running` to `Terminating`:
   ```
   NAME         READY   STATUS    RESTARTS   AGE
   my-mysql-0   1/1     Running   0          9m21s
   quarkus-jpa-mysql-jvm-00001-deployment-6c8c4556ff-6jxhf   0/2     Pending   0          0s
   quarkus-jpa-mysql-jvm-00001-deployment-6c8c4556ff-6jxhf   0/2     Pending   0          0s
   quarkus-jpa-mysql-jvm-00001-deployment-6c8c4556ff-6jxhf   0/2     ContainerCreating   0          0s
   quarkus-jpa-mysql-jvm-00001-deployment-6c8c4556ff-6jxhf   1/2     Running             0          2s
   quarkus-jpa-mysql-jvm-00001-deployment-6c8c4556ff-6jxhf   2/2     Running             0          11s
   quarkus-jpa-mysql-jvm-00001-deployment-6c8c4556ff-6jxhf   2/2     Terminating         0          71s
   quarkus-jpa-mysql-jvm-00001-deployment-6c8c4556ff-6jxhf   1/2     Terminating         0          101s
   quarkus-jpa-mysql-jvm-00001-deployment-6c8c4556ff-6jxhf   0/2     Terminating         0          102s
   quarkus-jpa-mysql-jvm-00001-deployment-6c8c4556ff-6jxhf   0/2     Terminating         0          102s
   quarkus-jpa-mysql-jvm-00001-deployment-6c8c4556ff-6jxhf   0/2     Terminating         0          102s
   ```

## Native vs JVM Comparison

The `Response Time`, present in the comparison table below, was obtained from the 1st request made to the services

| Service                  | Request        | Response Time | App startup |
|--------------------------|----------------|---------------|-------------|
| quarkus-jpa-mysql-native | GET /api/books | 2166 ms       | 61 ms       |
| quarkus-jpa-mysql-jvm    | GET /api/books | 5643 ms       | 3038 ms     |

By saying _1st request_, it means that the `Response Time` contains the sum of the following times:
- time for the caller's request to reach `Knative` cluster;
- time for `Knative` cluster to up-scale a `Pod` as none was running when the request arrived;
- time for the application (inside the Docker container) to start up, process the request and send back the response;
- time for the caller to receive the response from the network.

Subsequent requests will be handled pretty fast because the `Pod`s responsible to handle them are already up and running. After a period of inactivity, `Knative` cluster will terminate those `Pod`s, down-scaling them to `0`.

## Cleanup

- In a terminal, make sure you are inside `knative-minikube-environment/quarkus-jpa-mysql-native-vs-jvm` folder;

- Run the following script to uninstall everything installed in this example:
  ```
  ./cleanup.sh
  ```
