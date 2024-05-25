# knative-minikube-environment

The goal of this project is to set up [`Knative`](https://knative.dev/docs/) in [`Minikube`](https://minikube.sigs.k8s.io/docs/start/) and, deploy and run some [Serverless](https://martinfowler.com/articles/serverless.html) applications.

The `Knative` setup was mostly based on the [**Knative Official Documentation (v1.14)**](https://knative.dev/docs/install/)

## Proof-of-Concepts & Articles

On [ivangfr.github.io](https://ivangfr.github.io), I have compiled my Proof-of-Concepts (PoCs) and articles. You can easily search for the technology you are interested in by using the filter. Who knows, perhaps I have already implemented a PoC or written an article about what you are looking for.

## Prerequisites

- [`Kubectl`](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [`Minikube`](https://minikube.sigs.k8s.io/docs/start/)
- [`Helm`](https://helm.sh/docs/intro/install/)

## Examples

- ### [quarkus-jpa-mysql-native-vs-jvm](https://github.com/ivangfr/knative-minikube-environment/tree/master/quarkus-jpa-mysql-native-vs-jvm)
- ### [springboot-producer-consumer-native](https://github.com/ivangfr/knative-minikube-environment/tree/master/springboot-producer-consumer-native)

## Start Environment

- ### Start Minikube

  Open a terminal and run the following command to start `Minikube`
  ```
  minikube start --memory=8192 --cpus=4 --vm-driver=virtualbox
  ```

- ### Install Knative Serving & Eventing

  In a terminal, make sure you are in `knative-minikube-environment` root folder and run the scripts below
  ```
  ./install-knative-serving-kourier.sh
  ./install-knative-eventing-kafka.sh
  ```
  
  To verify Readiness and Status of all pods by running
  ```
  kubectl get pods --all-namespaces --watch
  ```
  > Press `Ctrl+C` to stop the watching mode
  
  Wait for all pods in `kourier-system`, `knative-serving` and `knative-eventing` namespaces to have `Running` value in the `STATUS` column before running the examples.

  You should see something like
  ```
  NAMESPACE          NAME                                          READY   STATUS    RESTARTS   AGE
  kafka              my-cluster-entity-operator-5b979bddd5-qwxjg   3/3     Running   0          33m
  kafka              my-cluster-kafka-0                            1/1     Running   0          33m
  kafka              my-cluster-zookeeper-0                        1/1     Running   0          34m
  kafka              strimzi-cluster-operator-677bf6869f-zq8xc     1/1     Running   0          34m
  knative-eventing   eventing-controller-7c6c467b7d-htlz9          1/1     Running   0          34m
  knative-eventing   eventing-webhook-8cf445799-48l88              1/1     Running   0          34m
  knative-eventing   kafka-controller-64d98ccf57-sbmrw             1/1     Running   0          32m
  knative-eventing   kafka-webhook-eventing-65445c9888-lnp8f       1/1     Running   0          32m
  knative-serving    activator-556dc846dd-x2ldt                    1/1     Running   0          37m
  knative-serving    autoscaler-57c75556d6-ggp82                   1/1     Running   0          37m
  knative-serving    controller-67d4f547cb-b25kz                   1/1     Running   0          37m
  knative-serving    domain-mapping-6646494575-mpctj               1/1     Running   0          37m
  knative-serving    domainmapping-webhook-5c89cfc845-9vrbl        1/1     Running   0          37m
  knative-serving    net-kourier-controller-8448499dd8-64p4j       1/1     Running   0          37m
  knative-serving    webhook-6f67fd848c-bs2xr                      1/1     Running   0          37m
  kourier-system     3scale-kourier-gateway-c5f49456b-9nwrk        1/1     Running   0          37m
  kube-system        coredns-787d4945fb-llqbg                      1/1     Running   1          17h
  kube-system        etcd-minikube                                 1/1     Running   1          17h
  kube-system        kube-apiserver-minikube                       1/1     Running   1          17h
  kube-system        kube-controller-manager-minikube              1/1     Running   1          17h
  kube-system        kube-proxy-4wpks                              1/1     Running   1          17h
  kube-system        kube-scheduler-minikube                       1/1     Running   1          17h
  kube-system        storage-provisioner                           1/1     Running   2          17h
  ```

## Shutdown Environment

- ### Uninstall Knative Serving & Eventing

  In a terminal, make sure you are in `knative-minikube-environment` root folder and run the scripts below
  ```
  ./uninstall-knative-serving-kourier.sh
  ./uninstall-knative-eventing-kafka.sh
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
