# knative-minikube-environment

The goal of this project is to setup [`Knative`](https://knative.dev/) in [`Minikube`](https://github.com/kubernetes/minikube) and then, deploy and run some [Serverless](https://martinfowler.com/articles/serverless.html) applications.

The setup of `Knative` was mostly based on the [**Knative Official Documentation (v0.15)**](https://knative.dev/docs/install/any-kubernetes-cluster/), except for some details about installing on Minikube that was based on [**Knative Official Documentation (v0.12)**](https://knative.dev/v0.12-docs/install/knative-with-minikube/)

## Prerequisites

- [`Kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [`Minikube`](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [`Helm`](https://helm.sh/docs/intro/install/)

## Examples

- ### [helloworld-go](https://github.com/ivangfr/knative-minikube-environment/tree/master/helloworld-go)
- ### [quarkus-bookapi-native-vs-jvm](https://github.com/ivangfr/knative-minikube-environment/tree/master/quarkus-bookapi-native-vs-jvm)

## Start Environment

- ### Start Minikube

  In a terminal, run the command below to start `Minikube`
  ```
  minikube start \
    --memory=8192 \
    --cpus=4 \
    --vm-driver=virtualbox \
    --disk-size=30g \
    --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"
  ```

- ### Install Knative & Kong

  `Knative` depends on a Service Gateway to handle traffic routing and ingress. In this tutorial, we will use [`Kong`](https://konghq.com/kong/).

  Run the script below to install `Knative` and `Kong`
  ```
  ./install-knative-kong.sh
  ```
  
  To verify Readiness and Status of all pods by running
  ```
  kubectl get pods --all-namespaces -w
  ```
  > Press `Ctrl+C` to stop the watching mode
  
  Wait for all pods in `knative-serving` and `kong` namespaces to the have `Running` value in the `STATUS` column before proceeding to the examples.

## Shutdown Environment

- ### Uninstall Knative & Kong

  Run the script below to uninstall `Knative` and `Kong`
  ```
  ./uninstall-knative-kong.sh
  ```

- ### Shutdown Minikube

  The following command shuts down the `Minikube Virtual Machine`, but preserves all cluster state and data. Starting the cluster again will restore it to its previous state.
  ```
  minikube stop
  ```

  The command shuts down and deletes the `Minikube Virtual Machine`. No data or state is preserved.
  ```
  minikube delete
  ```

## Troubleshooting

- **Service not READY**

  After installing a service and checking its status, it stays at `READY: False; REASON: RevisionMissing`. The only way I know to solve it is to delete (`kubectl delete`) and apply (`kubectl apply`) the service again.

  Here are some steps that can help you to troubleshoot it

  - Run the command below and check the value in the column `READY`. It must be `True`
    ```
    kubectl get ksvc --namespace dev
    ```

  - Get more information about the service, describing it
    ```
    kubectl describe ksvc --namespace dev <service-name>
    ```

- **404 Not Found**

  Usually, it happens when the service is not `READY`. See **Service not READY**
