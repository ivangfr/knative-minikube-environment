# knative-minikube-environment

The goal of this project is to set up [`Knative`](https://knative.dev/) in [`Minikube`](https://github.com/kubernetes/minikube) and, deploy and run some [Serverless](https://martinfowler.com/articles/serverless.html) applications.

The `Knative` setup was mostly based on the [**Knative Official Documentation (v0.23)**](https://knative.dev/docs/install/install-serving-with-yaml/)

## Prerequisites

- [`Kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [`Minikube`](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [`Helm`](https://helm.sh/docs/intro/install/)

## Examples

- ### [helloworld-go](https://github.com/ivangfr/knative-minikube-environment/tree/master/helloworld-go)
- ### [quarkus-jpa-mysql-native-vs-jvm](https://github.com/ivangfr/knative-minikube-environment/tree/master/quarkus-jpa-mysql-native-vs-jvm)

## Start Environment

- ### Start Minikube

  Open a terminal and run the following command to start `Minikube`
  ```
  minikube start --memory=8192 --cpus=4 --vm-driver=virtualbox
  ```

- ### Install Knative & Kong

  `Knative` depends on a Service Gateway to handle traffic routing and ingress. In this tutorial, we will use [`Kong`](https://konghq.com/kong/).

  In a terminal, make sure you are in `knative-minikube-environment` root folder and run the script below to install `Knative` and `Kong`
  ```
  ./install-knative-kong.sh
  ```
  
  To verify Readiness and Status of all pods by running
  ```
  kubectl get pods --all-namespaces -w
  ```
  > Press `Ctrl+C` to stop the watching mode
  
  Wait for all pods in `knative-serving` and `kong` namespaces to the have `Running` value in the `STATUS` column before running the examples.

  You should see something like
  ```
  NAMESPACE         NAME                               READY   STATUS    RESTARTS   AGE
  knative-serving   activator-8586b94b8b-59q6f         1/1     Running   0          2m7s
  knative-serving   autoscaler-55b786c8b8-xrplb        1/1     Running   0          2m7s
  knative-serving   controller-5f47f4d7c5-g4l7n        1/1     Running   0          2m7s
  knative-serving   webhook-5f755b99b9-s7vjr           1/1     Running   0          2m7s
  kong              ingress-kong-c7c8668d-dxdbk        2/2     Running   0          2m6s
  kube-system       coredns-74ff55c5b-5j8db            1/1     Running   0          2m58s
  kube-system       etcd-minikube                      1/1     Running   0          3m12s
  kube-system       kube-apiserver-minikube            1/1     Running   0          3m12s
  kube-system       kube-controller-manager-minikube   1/1     Running   0          3m12s
  kube-system       kube-proxy-njftg                   1/1     Running   0          2m58s
  kube-system       kube-scheduler-minikube            1/1     Running   0          3m12s
  kube-system       storage-provisioner                1/1     Running   1          3m12s
  ```

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
