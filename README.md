# knative-minikube-environment

The goal of this project is to set up [`Knative`](https://knative.dev/docs/) in [`Minikube`](https://minikube.sigs.k8s.io/docs/start/) and, deploy and run some [Serverless](https://martinfowler.com/articles/serverless.html) applications.

The `Knative` setup was mostly based on the [**Knative Official Documentation (v1.3)**](https://knative.dev/docs/install/)

## Prerequisites

- [`Kubectl`](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [`Minikube`](https://minikube.sigs.k8s.io/docs/start/)
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

- ### Install Knative Serving

  `Knative` depends on a Service Gateway to handle traffic routing and ingress. In this tutorial, we will use [`Kourier`](https://github.com/knative-sandbox/net-kourier).

  In a terminal, make sure you are in `knative-minikube-environment` root folder and run the script below
  ```
  ./install-knative-serving-kourier.sh
  ```
  
  To verify Readiness and Status of all pods by running
  ```
  kubectl get pods --all-namespaces --watch
  ```
  > Press `Ctrl+C` to stop the watching mode
  
  Wait for all pods in `knative-serving` and `kourier-system` namespaces to the have `Running` value in the `STATUS` column before running the examples.

  You should see something like
  ```
  NAMESPACE         NAME                                      READY   STATUS    RESTARTS        AGE
  knative-serving   activator-66bcc86b86-p5xwd                1/1     Running   0               4m53s
  knative-serving   autoscaler-6b88c666fc-2phfx               1/1     Running   0               4m53s
  knative-serving   controller-59c69fb58d-c5ntd               1/1     Running   0               4m53s
  knative-serving   domain-mapping-5c4b8d79f-tjqkt            1/1     Running   0               4m53s
  knative-serving   domainmapping-webhook-777f47b8bb-7jmsv    1/1     Running   0               4m53s
  knative-serving   net-kourier-controller-74dc74797-jtxcl    1/1     Running   0               4m51s
  knative-serving   webhook-6d6d8c5b4f-xhscq                  1/1     Running   0               4m53s
  kourier-system    3scale-kourier-gateway-75c75885fd-w8jnk   1/1     Running   0               4m51s
  kube-system       coredns-64897985d-hxppc                   1/1     Running   0               5m42s
  kube-system       etcd-minikube                             1/1     Running   0               5m57s
  kube-system       kube-apiserver-minikube                   1/1     Running   0               5m54s
  kube-system       kube-controller-manager-minikube          1/1     Running   0               5m54s
  kube-system       kube-proxy-kbf7w                          1/1     Running   0               5m42s
  kube-system       kube-scheduler-minikube                   1/1     Running   0               5m54s
  kube-system       storage-provisioner                       1/1     Running   1 (5m12s ago)   5m53s
  ```

## Shutdown Environment

- ### Uninstall Knative Serving

  Run the script below to uninstall `Knative` and `Kourier`
  ```
  ./uninstall-knative-serving-kourier.sh
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
    kubectl describe ksvc <service-name> --namespace dev
    ```

- **404 Not Found**

  Usually, it happens when the service is not `READY`. See **Service not READY**
