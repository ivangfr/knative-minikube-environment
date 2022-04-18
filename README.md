# knative-minikube-environment

The goal of this project is to set up [`Knative`](https://knative.dev/docs/) in [`Minikube`](https://minikube.sigs.k8s.io/docs/start/) and, deploy and run some [Serverless](https://martinfowler.com/articles/serverless.html) applications.

The `Knative` setup was mostly based on the [**Knative Official Documentation (v1.3)**](https://knative.dev/docs/install/)

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
  
  Wait for all pods in `knative-serving`, `kourier-system`, `knative-eventing`, and `kafka` namespaces to the have `Running` value in the `STATUS` column before running the examples.

  You should see something like
  ```
  NAMESPACE          NAME                                                 READY   STATUS    RESTARTS      AGE
  kafka              my-cluster-entity-operator-67cbb8f86f-ngf2k          3/3     Running   0             115s
  kafka              my-cluster-kafka-0                                   1/1     Running   0             2m18s
  kafka              my-cluster-zookeeper-0                               1/1     Running   0             2m40s
  kafka              strimzi-cluster-operator-7599bc57cb-d68f7            1/1     Running   0             2m52s
  knative-eventing   eventing-controller-69897c84c-2t2tx                  1/1     Running   0             2m55s
  knative-eventing   eventing-kafka-channel-controller-5f7558cf76-rh5qz   1/1     Running   0             80s
  knative-eventing   eventing-webhook-79cdbf9b9f-ff48r                    1/1     Running   0             2m55s
  knative-eventing   kafka-broker-dispatcher-67bb58bd94-4kdw7             1/1     Running   0             74s
  knative-eventing   kafka-broker-receiver-844cd677dc-n6n79               1/1     Running   0             74s
  knative-eventing   kafka-ch-controller-9695954cb-9rjjn                  1/1     Running   0             82s
  knative-eventing   kafka-controller-7d8fc874f8-qzb99                    1/1     Running   0             77s
  knative-eventing   kafka-controller-manager-5c947968f7-tlb7g            1/1     Running   0             83s
  knative-eventing   kafka-webhook-7dfdcdfb78-7qnt4                       1/1     Running   0             80s
  knative-eventing   kafka-webhook-eventing-cd65cb565-lj9wv               1/1     Running   0             77s
  knative-serving    activator-66bcc86b86-v2ndd                           1/1     Running   0             3m19s
  knative-serving    autoscaler-6b88c666fc-xs59k                          1/1     Running   0             3m18s
  knative-serving    controller-59c69fb58d-8vdfj                          1/1     Running   0             3m18s
  knative-serving    domain-mapping-5c4b8d79f-7xbz9                       1/1     Running   0             3m18s
  knative-serving    domainmapping-webhook-777f47b8bb-6d4jm               1/1     Running   0             3m18s
  knative-serving    net-kourier-controller-74dc74797-xrwzx               1/1     Running   0             3m16s
  knative-serving    webhook-6d6d8c5b4f-cmc66                             1/1     Running   0             3m18s
  kourier-system     3scale-kourier-gateway-75c75885fd-vvhk2              1/1     Running   0             3m16s
  kube-system        coredns-64897985d-j7jln                              1/1     Running   4 (13h ago)   40h
  kube-system        etcd-minikube                                        1/1     Running   4 (13h ago)   40h
  kube-system        kube-apiserver-minikube                              1/1     Running   4 (13h ago)   40h
  kube-system        kube-controller-manager-minikube                     1/1     Running   4 (13h ago)   40h
  kube-system        kube-proxy-g2psf                                     1/1     Running   4 (13h ago)   40h
  kube-system        kube-scheduler-minikube                              1/1     Running   4 (13h ago)   40h
  kube-system        storage-provisioner                                  1/1     Running   8 (38m ago)   40h
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
