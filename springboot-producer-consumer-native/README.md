# knative-minikube-environment
## `> springboot-producer-consumer-native`

The goal of this example is to run in `Knative` cluster a project called `springboot-producer-consumer-native` whose source code can be found in the [ivangfr/graalvm-quarkus-micronaut-springboot](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot/tree/master/producer-consumer/springboot-producer-consumer) repository.

`springboot-producer-consumer-native` is composed by two [`Spring Boot`](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/) Java Web applications, both were built using [`GraalVM Native Image`](https://www.graalvm.org/docs/reference-manual/native-image/)

- **springboot-producer-api-native**

  It exposes one endpoint at which users can post `news`. Once a request is made, the application pushes a message about the `news` to `Kafka`.
  ```
  POST /api/news {"source": "...", "title": "..."}
  ```

  The Docker native image can be found at https://hub.docker.com/r/ivanfranchin/springboot-producer-api-native
  
- **springboot-consumer-api-native**

  It listens to messages (published by the `producer-api`) and logs it.

  The Docker native image can be found at https://hub.docker.com/r/ivanfranchin/springboot-consumer-api-native

## Start Minikube and Install Knative

First, start `Minikube` and install `Knative` as explained at [Start Environment](https://github.com/ivangfr/knative-minikube-environment#start-environment) in the main README.

## Start Environment

1. Open a terminal and navigate to `knative-minikube-environment/springboot-producer-consumer-native` folder

1. Let's pull `springboot-producer-api-native` and `springboot-consumer-api-native` Docker images

   1. Set `Minikube` host
      ```
      eval $(minikube docker-env)
      ```
      
   1. Pull the following Docker images
      ```
      docker pull ivanfranchin/springboot-producer-api-native:1.0.0
      docker pull ivanfranchin/springboot-consumer-api-native:1.0.0
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

## Install springboot-producer-consumer-native services

1. In a terminal and inside `knative-minikube-environment/springboot-producer-consumer-native` folder, run the following commands
   ```
   kubectl apply --namespace dev --filename yaml-files/springboot-producer-api-native-service.yaml
   kubectl apply --namespace dev --filename yaml-files/springboot-consumer-api-native-service.yaml
   ```
   > To delete run
   > ```
   > kubectl delete --namespace dev --filename yaml-files/springboot-producer-api-native-service.yaml
   > kubectl delete --namespace dev --filename yaml-files/springboot-consumer-api-native-service.yaml
   > ```

1. You can watch the installation of the services by running
   ```
   kubectl get pods --namespace dev --watch
   ```
   > Press `Ctrl+C` to stop the watching mode

1. To get more details about the services run
   ```
   kubectl describe ksvc --namespace dev springboot-producer-api-native
   kubectl describe ksvc --namespace dev springboot-consumer-api-native
   ```
   
1. Before continue, verify if the services are ready to receive requests
   ```
   kubectl get ksvc --namespace dev
   ```
   
   They must have the value `True` in the column `READY`. If not, wait a bit or check [Troubleshooting](https://github.com/ivangfr/knative-minikube-environment#troubleshooting).
   
1. Make post request to `springboot-producer-api-native`
   
   1. Get `Kourier` Ingress Gateway IP Address
      ```
      ../get-kourier-external-ip-address.sh
      ```

   1. Set the `EXTERNAL_IP_ADDRESS` environment variable in a terminal
      ```
      EXTERNAL_IP_ADDRESS=...
      ``` 

   1. Post news
      ```
      curl -i -H "Host: springboot-producer-api-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/news \
        -H "Content-Type: application/json" -d '{"source": "CNN", "title": " Palmeiras wins Libertadores in 2021"}'
      ```
   
   1. Check pod logs
      ```
      kubectl get pods --namespace dev
      kubectl logs --namespace dev <springboot-producer-api-native-pod-name> user-container
      kubectl logs --namespace dev <springboot-consumer-api-native-pod-name> user-container
      ```

## Example of Execution

1. Watching Pods in `dev` namespace. Just producer and consumer `Kafka Source` are running.
   ```
   $ kubectl get pods --namespace dev --watch

   NAME                                                              READY   STATUS    RESTARTS   AGE
   kafkasource-consumer-news-a15d5d6e-118b-4738-9eb4-b65f276e5kxsp   1/1     Running   0          12m
   kafkasource-producer-news-908af31d-87b2-4b3f-b7e3-f417445bd8kcp   1/1     Running   0          12m
   ```

1. Post news
   ```
   curl -i -H "Host: springboot-producer-api-native.dev.example.com" http://$EXTERNAL_IP_ADDRESS/api/news \
     -H "Content-Type: application/json" -d '{"source": "CNN", "title": " Palmeiras wins Libertadores in 2021"}'

   HTTP/1.1 200 OK
   content-length: 36
   content-type: text/plain;charset=UTF-8
   date: Sun, 17 Apr 2022 14:47:54 GMT
   x-envoy-upstream-service-time: 2157
   server: envoy
   
   61268f38-efbd-45b9-8c3c-9b2b31a7eccc
   ```

1. Watching `springboot-producer-api-native` and `springboot-consumer-api-native` Pods changing from `ContainerCreating`, `Running` to `Terminating`
   ```
   $ kubectl get pods --namespace dev --watch

   NAME                                                              READY   STATUS    RESTARTS   AGE
   kafkasource-consumer-news-a15d5d6e-118b-4738-9eb4-b65f276e5kxsp   1/1     Running   0          12m
   kafkasource-producer-news-908af31d-87b2-4b3f-b7e3-f417445bd8kcp   1/1     Running   0          12m
   springboot-producer-api-native-00001-deployment-688bffd4cdhpn2l   0/2     Pending   0          0s
   springboot-producer-api-native-00001-deployment-688bffd4cdhpn2l   0/2     Pending   0          1s
   springboot-producer-api-native-00001-deployment-688bffd4cdhpn2l   0/2     ContainerCreating   0          1s
   springboot-producer-api-native-00001-deployment-688bffd4cdhpn2l   1/2     Running             0          2s
   springboot-producer-api-native-00001-deployment-688bffd4cdhpn2l   2/2     Running             0          2s
   springboot-consumer-api-native-00001-deployment-c7bd7f5bb-kbdxb   0/2     Pending             0          0s
   springboot-consumer-api-native-00001-deployment-c7bd7f5bb-kbdxb   0/2     Pending             0          0s
   springboot-consumer-api-native-00001-deployment-c7bd7f5bb-kbdxb   0/2     ContainerCreating   0          0s
   springboot-consumer-api-native-00001-deployment-c7bd7f5bb-kbdxb   1/2     Running             0          2s
   springboot-consumer-api-native-00001-deployment-c7bd7f5bb-kbdxb   2/2     Running             0          2s
   springboot-producer-api-native-00001-deployment-688bffd4cdhpn2l   2/2     Terminating         0          66s
   springboot-consumer-api-native-00001-deployment-c7bd7f5bb-kbdxb   2/2     Terminating         0          65s
   springboot-producer-api-native-00001-deployment-688bffd4cdhpn2l   0/2     Terminating         0          99s
   springboot-producer-api-native-00001-deployment-688bffd4cdhpn2l   0/2     Terminating         0          99s
   springboot-producer-api-native-00001-deployment-688bffd4cdhpn2l   0/2     Terminating         0          99s
   springboot-consumer-api-native-00001-deployment-c7bd7f5bb-kbdxb   0/2     Terminating         0          97s
   springboot-consumer-api-native-00001-deployment-c7bd7f5bb-kbdxb   0/2     Terminating         0          97s
   springboot-consumer-api-native-00001-deployment-c7bd7f5bb-kbdxb   0/2     Terminating         0          97s
   ```

## Cleanup

- In a terminal, make sure you are inside `knative-minikube-environment/springboot-producer-consumer-native` folder

- Run the following script to uninstall everything installed in this example
  ```
  ./cleanup.sh
  ```
