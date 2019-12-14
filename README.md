# `knative-minikube-environment`

The goal of this project is to setup [`Knative`](https://knative.dev/) in [`Minikube`](https://github.com/kubernetes/minikube) and then, deploy and run some [serverless](https://martinfowler.com/articles/serverless.html) applications.

The setup of `Knative` in `Minikube` was mostly based on the **Knative Official Documentation (v0.11)**: [Install on Minikube](https://knative.dev/docs/install/knative-with-minikube/), [Installing Istio for Knative](https://knative.dev/docs/install/installing-istio) and [Installing Knative with Ambassador](https://knative.dev/docs/install/knative-with-ambassador/).

## Prerequisites

You must have `Kubectl`, `Minikube` and `Helm` installed in your machine. Here are the links to websites that explain how to install [`Kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/), [`Minikube`](https://kubernetes.io/docs/tasks/tools/install-minikube/) and [`Helm`](https://helm.sh/docs/intro/install/)

## Examples

- ### [helloworld-go](https://github.com/ivangfr/knative-minikube-environment/tree/master/helloworld-go)
- ### [quarkus-bookapi-native-vs-jvm](https://github.com/ivangfr/knative-minikube-environment/tree/master/quarkus-bookapi-native-vs-jvm)

## Start Environment

### Start Minikube

In a terminal, run the command below to start `Minikube`
```
minikube start \
  --memory=8192 \
  --cpus=4 \
  --vm-driver=virtualbox \
  --disk-size=30g \
  --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"
```

### Install Knative

`Knative` depends on a Service Gateway to handle traffic routing and ingress. In this tutorial, we will work with [`Istio`](https://istio.io/) and [`Ambassador`](https://www.getambassador.io/)

You can pick the one you prefer

- #### Install Knative with Istio

  Run the script below to install `Knative` and `Istio`
  ```
  ./install-knative-istio.sh
  ```

- #### Install Knative with Ambassador

  Run the following script to install `Knative` and `Ambassador`
  ```
  ./install-knative-ambassador.sh
  ```

## Shutdown Environment

### Uninstall Knative

- #### Uninstall Knative with Istio

  Run the script below to uninstall `Knative` and `Istio`
  ```
  ./uninstall-knative-istio.sh
  ```

- #### Uninstall Knative with Ambassador

  Run the following script to uninstall `Knative` and `Ambassador`
  ```
  ./uninstall-knative-ambassador.sh
  ```

### Shutdown Minikube

The following command shuts down the `Minikube Virtual Machine`, but preserves all cluster state and data. Starting the cluster again will restore it to it’s previous state.
```
minikube stop
```

The command shuts down and deletes the `Minikube Virtual Machine`. No data or state is preserved.
```
minikube delete
```

## Troubleshooting

- ### 404 Not Found

  Sometimes, after installing a service and making a request to it, you get `404 Not Found` as response. Honestly, the only way I know to solve is to delete (`kubectl delete`) and apply (`kubectl apply`) the service again.
  
  Here are some steps that can help you to troubleshoot it
  
  - Run the command below and check the value in the column `READY`. It must be `True`
    ```
    kubectl get ksvc --namespace dev
    ```
    
  - Get more information about the service, describing it
    ```
    kubectl describe ksvc --namespace dev <service-name>
    ```

- ### 504 Gateway Timeout

  When using `Knative` with `Ambassador` you can get `504 Gateway Timeout` as response. That is because `Ambassador` has a timeout of `3000 ms`. So, the `Knative` cluster doesn't have time to start a `Pod` to handle the request.
  
  Subsequents requests will work as the `Pod` is already up and running.
