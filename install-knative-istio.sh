#!/usr/bin/env bash

# This script was implemented based on the Knative Official Documentation (v0.11)
# - Install on Minikube: https://knative.dev/docs/install/knative-with-minikube/
# - Installing Istio for Knative: https://knative.dev/docs/install/installing-istio

echo
echo "Installing Istio"
echo "================"

echo
echo "Download and unpack Istio"
echo "========================="

export ISTIO_VERSION=1.4.2 # Check https://github.com/istio/istio/releases/ for new releases
curl -L https://git.io/getLatestIstio | sh -
cd istio-${ISTIO_VERSION}

echo
echo "Install Istio CRDs"
echo "------------------"

for i in install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done

echo
echo "Create istio-system namespace"
echo "-----------------------------"

kubectl create ns istio-system
kubectl label ns istio-system istio-injection=disabled

echo
echo "Generate istio-lean.yaml"
echo "------------------------"

# Note: It is an Istio configuration without sidecar injection

helm template --namespace=istio-system \
	--set prometheus.enabled=false \
	--set mixer.enabled=false \
	--set mixer.policy.enabled=false \
	--set mixer.telemetry.enabled=false \
	`# Pilot doesnt need a sidecar.` \
	--set pilot.sidecar=false \
	--set pilot.resources.requests.memory=128Mi \
	`# Disable galley (and things requiring galley).` \
	--set galley.enabled=false \
	--set global.useMCP=false \
	`# Disable security / policy.` \
	--set security.enabled=false \
	--set global.disablePolicyChecks=true \
	`# Disable sidecar injection.` \
	--set sidecarInjectorWebhook.enabled=false \
	--set global.proxy.autoInject=disabled \
	--set global.omitSidecarInjectorConfigMap=true \
	--set gateways.istio-ingressgateway.autoscaleMin=1 \
	--set gateways.istio-ingressgateway.autoscaleMax=2 \
	`# Set pilot trace sampling to 100%` \
	--set pilot.traceSampling=100 \
	install/kubernetes/helm/istio \
	> ./istio-lean.yaml

echo
echo "Install Istio using istio-lean.yaml"
echo "-----------------------------------"

kubectl apply -f istio-lean.yaml

echo
echo "Going back to root folder"
echo "-------------------------"

cd ..

echo
echo "Installing Knative"
echo "=================="

echo
echo "Install Knative CRDs"
echo "--------------------"

# Note: Monitoring was disabled because it's too heavy for Minikube
kubectl apply \
   --selector knative.dev/crd-install=true \
   --filename https://github.com/knative/serving/releases/download/v0.11.0/serving.yaml \
   --filename https://github.com/knative/eventing/releases/download/v0.11.0/release.yaml \
   `#--filename https://github.com/knative/serving/releases/download/v0.11.0/monitoring.yaml`

echo
echo "Complete install of Knative and its dependencies"
echo "------------------------------------------------"

# Note: Monitoring was disabled because it's too heavy for Minikube
kubectl apply \
   --filename https://github.com/knative/serving/releases/download/v0.11.0/serving.yaml \
   --filename https://github.com/knative/eventing/releases/download/v0.11.0/release.yaml \
   `#--filename https://github.com/knative/serving/releases/download/v0.11.0/monitoring.yaml`

echo
echo "Istio External IP Address"
echo "-------------------------"

INGRESSGATEWAY=istio-ingressgateway
EXTERNAL_IP_ADDRESS=$(minikube ip):$(kubectl get svc $INGRESSGATEWAY --namespace istio-system --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')

echo "EXTERNAL_IP_ADDRESS=$EXTERNAL_IP_ADDRESS"

echo
echo "Knative-Istio setup completed successfully"
echo "=========================================="
echo
echo "To verify readiness and status of all pods : kubectl get pods --all-namespaces"
echo "To export Istio External IP Address        : export EXTERNAL_IP_ADDRESS=$EXTERNAL_IP_ADDRESS"
echo
