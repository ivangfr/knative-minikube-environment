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

- \[**Medium**\] [**Setting Up Knative in Minikube (Kubernetes) for Serverless Applications**](https://medium.com/@ivangfr/setting-up-knative-in-minikube-kubernetes-for-serverless-applications-181fb20f3d19)

## Install springboot-producer-consumer-native services & Example of Executions

- \[**Medium**\] [**Deploying Serverless Producer & Consumer Spring Boot Apps in Knative Minikube (Kubernetes)**](https://medium.com/@ivangfr/deploying-serverless-producer-consumer-spring-boot-apps-in-knative-minikube-kubernetes-c58bb26b1f08)
