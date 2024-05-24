# knative-minikube-environment
## `> springboot-producer-consumer-native`

The goal of this example is to run in `Knative` cluster a project called `springboot-producer-consumer-native` whose source code can be found in the [ivangfr/graalvm-quarkus-micronaut-springboot](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot/tree/master/kafka/springboot-kafka) repository.

`springboot-producer-consumer-native` is composed by two [`Spring Boot`](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/) Java Web applications, both were built using [`GraalVM Native Image`](https://www.graalvm.org/docs/reference-manual/native-image/)

- **springboot-kafka-producer-native**

  It exposes one endpoint at which users can post `news`. Once a request is made, the application pushes a message about the `news` to `Kafka`.
  ```
  POST /api/news {"source": "...", "title": "..."}
  ```

  The Docker native image can be found at https://hub.docker.com/r/ivanfranchin/springboot-kafka-producer-native
  
- **springboot-kafka-consumer-native**

  It listens to messages (published by the `producer-api`) and logs it.

  The Docker native image can be found at https://hub.docker.com/r/ivanfranchin/springboot-kafka-consumer-native

## Start Minikube and Install Knative

First, start `Minikube` and install `Knative` as explained at [Start Environment](https://github.com/ivangfr/knative-minikube-environment#start-environment) in the main README.

## Start Environment

1. Open a terminal and navigate to `knative-minikube-environment/springboot-producer-consumer-native` folder.

2. Let's pull `springboot-kafka-producer-native` and `springboot-kafka-consumer-native` Docker images

   1. Set `Minikube` host:
      ```
      eval $(minikube docker-env)
      ```
      
   2. Pull the following Docker images:
      ```
      docker pull ivanfranchin/springboot-kafka-producer-native:latest
      docker pull ivanfranchin/springboot-kafka-consumer-native:latest
      ```
      
   3. Get back to Host machine Docker Daemon:
      ```
      eval $(minikube docker-env -u)
      ```

3. Create the `dev` namespace:
   ```
   kubectl create namespace dev
   ```
   > To delete run
   > ```
   > kubectl delete namespace dev
   > ```

## Install springboot-producer-consumer-native services

1. In a terminal and inside `knative-minikube-environment/springboot-producer-consumer-native` folder, run the following commands:
   ```
   kubectl apply --namespace dev --filename yaml-files/springboot-kafka-producer-native-service.yaml
   kubectl apply --namespace dev --filename yaml-files/springboot-kafka-consumer-native-service.yaml
   ```
   > To delete run:
   > ```
   > kubectl delete --namespace dev --filename yaml-files/springboot-kafka-producer-native-service.yaml
   > kubectl delete --namespace dev --filename yaml-files/springboot-kafka-consumer-native-service.yaml
   > ```

2. You can watch the installation of the services by running:
   ```
   kubectl get pods --namespace dev --watch
   ```
   > Press `Ctrl+C` to stop the watching mode.

3. To get more details about the services run:
   ```
   kubectl describe ksvc --namespace dev springboot-kafka-producer-native
   kubectl describe ksvc --namespace dev springboot-kafka-consumer-native
   ```
   
4. Before continue, verify if the services are ready to receive requests:
   ```
   kubectl get ksvc --namespace dev
   ```

   They must have the value `True` in the column `READY`. If not, wait a bit or check [Troubleshooting](https://github.com/ivangfr/knative-minikube-environment#troubleshooting).
   ```
   NAME                               URL                                                       LATESTCREATED                            LATESTREADY                              READY   REASON
   springboot-kafka-consumer-native   http://springboot-kafka-consumer-native.dev.example.com   springboot-kafka-consumer-native-00001   springboot-kafka-consumer-native-00001   True
   springboot-kafka-producer-native   http://springboot-kafka-producer-native.dev.example.com   springboot-kafka-producer-native-00001   springboot-kafka-producer-native-00001   True
   ```
   
5. Make post request to `springboot-kafka-producer-native`
   
   1. Get `Kourier` Ingress Gateway IP Address
      ```
      ../get-kourier-external-ip-address.sh
      ```

   2. Set the `EXTERNAL_IP_ADDRESS` environment variable in a terminal
      ```
      EXTERNAL_IP_ADDRESS=...
      ``` 

   3. Post news
      ```
      curl -i -H "Host: springboot-kafka-producer-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/news \
        -H "Content-Type: application/json" -d '{"source": "CNN", "title": " Palmeiras wins Libertadores in 2021"}'
      ```
   
   4. Check Pod logs
      ```
      kubectl get pods --namespace dev
      kubectl logs --namespace dev <springboot-kafka-producer-native-pod-name> user-container
      kubectl logs --namespace dev <springboot-kafka-consumer-native-pod-name> user-container
      ```

## Example of Execution

1. In a terminal, start watching the Pods in `dev` namespace. In my case, nothing is running.
   ```
   kubectl get pods --namespace dev --watch
   ```

2. In another terminal, run the `curl` command below to post a news:
   ```
   curl -i -H "Host: springboot-kafka-producer-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/news \
     -H "Content-Type: application/json" -d '{"source": "CNN", "title": " Palmeiras wins Libertadores in 2021"}'
   ```

   It should return something like:
   ```
   HTTP/1.1 200 OK
   content-length: 36
   content-type: text/plain;charset=UTF-8
   date: Mon, 06 Mar 2023 10:33:27 GMT
   x-envoy-upstream-service-time: 1976
   server: envoy
   
   61df6cf1-9fd8-4c6a-9539-32b25f557e45
   ```
   In this example, the response was returned in `1976 ms`.

3. In the first terminal, watch `springboot-kafka-producer-native` and `springboot-kafka-consumer-native` Pods changing from `ContainerCreating`, `Running` to `Terminating`:
   ```
   NAME         READY   STATUS    RESTARTS   AGE
   springboot-kafka-producer-native-00001-deployment-5d86f765q6hxb   0/2     Pending   0          0s
   springboot-kafka-producer-native-00001-deployment-5d86f765q6hxb   0/2     Pending   0          1s
   springboot-kafka-producer-native-00001-deployment-5d86f765q6hxb   0/2     ContainerCreating   0          1s
   springboot-kafka-producer-native-00001-deployment-5d86f765q6hxb   1/2     Running             0          2s
   springboot-kafka-producer-native-00001-deployment-5d86f765q6hxb   2/2     Running             0          2s
   springboot-kafka-consumer-native-00001-deployment-6f94cdc6m49rv   0/2     Pending             0          0s
   springboot-kafka-consumer-native-00001-deployment-6f94cdc6m49rv   0/2     Pending             0          0s
   springboot-kafka-consumer-native-00001-deployment-6f94cdc6m49rv   0/2     ContainerCreating   0          0s
   springboot-kafka-consumer-native-00001-deployment-6f94cdc6m49rv   1/2     Running             0          2s
   springboot-kafka-consumer-native-00001-deployment-6f94cdc6m49rv   2/2     Running             0          2s
   springboot-kafka-producer-native-00001-deployment-5d86f765q6hxb   2/2     Terminating         0          64s
   springboot-kafka-producer-native-00001-deployment-5d86f765q6hxb   1/2     Terminating         0          91s
   springboot-kafka-producer-native-00001-deployment-5d86f765q6hxb   0/2     Terminating         0          97s
   springboot-kafka-producer-native-00001-deployment-5d86f765q6hxb   0/2     Terminating         0          97s
   springboot-kafka-producer-native-00001-deployment-5d86f765q6hxb   0/2     Terminating         0          97s
   springboot-kafka-consumer-native-00001-deployment-6f94cdc6m49rv   2/2     Terminating         0          2m18s
   springboot-kafka-consumer-native-00001-deployment-6f94cdc6m49rv   1/2     Terminating         0          2m40s
   springboot-kafka-consumer-native-00001-deployment-6f94cdc6m49rv   0/2     Terminating         0          2m50s
   springboot-kafka-consumer-native-00001-deployment-6f94cdc6m49rv   0/2     Terminating         0          2m50s
   springboot-kafka-consumer-native-00001-deployment-6f94cdc6m49rv   0/2     Terminating         0          2m50s
   ```

## Cleanup

- In a terminal, make sure you are inside `knative-minikube-environment/springboot-producer-consumer-native` folder;

- Run the following script to uninstall everything installed in this example:
  ```
  ./cleanup.sh
  ```
