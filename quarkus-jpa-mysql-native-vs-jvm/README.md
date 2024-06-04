# knative-minikube-environment
## `> quarkus-jpa-mysql-native-vs-jvm`

The goal of this example is to run in `Knative` cluster an application called `quarkus-jpa-mysql` whose source code can be found in the [ivangfr/graalvm-quarkus-micronaut-springboot](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot/tree/master/jpa-mysql/quarkus-jpa-mysql) repository.

`quarkus-jpa-mysql` is a [`Quarkus`](https://quarkus.io/) Java Web application that exposes a REST API for managing `books`. It uses [`MySQL`](https://www.mysql.com/) as database.

We will run two `quarkus-jpa-mysql` Docker images:
- [`quarkus-jpa-mysql-jvm`](https://hub.docker.com/r/ivanfranchin/quarkus-jpa-mysql-jvm) whose Docker image was built in order to have a container that runs the application in **JVM mode**;
- [`quarkus-jpa-mysql-native`](https://hub.docker.com/r/ivanfranchin/quarkus-jpa-mysql-native) whose Docker image built using [`GraalVM Native Image`](https://www.graalvm.org/docs/reference-manual/native-image/) tool in order to have a container that runs the application in **Native mode**.

More about the comparison between `JVM` vs `Native` and among Java Frameworks can be found in [ivangfr/graalvm-quarkus-micronaut-springboot](https://github.com/ivangfr/graalvm-quarkus-micronaut-springboot) repository.

## Start Minikube and Install Knative

- \[**Medium**\] [**Setting Up Knative in Minikube (Kubernetes) for Serverless Applications**](https://medium.com/@ivangfr/setting-up-knative-in-minikube-kubernetes-for-serverless-applications-181fb20f3d19)

## Install quarkus-jpa-mysql services & Example of Executions

- \[**Medium**\] [**Deploying Serverless Quarkus JPA App in Knative Minikube (Kubernetes)**](https://medium.com/@ivangfr/deploying-serverless-quarkus-jpa-app-in-knative-minikube-kubernetes-fc29f98ffc7c)
