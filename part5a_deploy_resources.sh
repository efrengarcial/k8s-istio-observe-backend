#!/bin/bash
#
# author: Gary A. Stafford
# site: https://programmaticponderings.com
# license: MIT License
# purpose: Optional: Deploy Kubernetes/Istio resources

# Constants - CHANGE ME!
readonly NAMESPACES=(dev)
readonly SERVICES=(a b c d e f g h)


# Create Namespaces
kubectl apply -f ./resources/other/namespaces.yaml
kubectl apply -f ./resources/other/istio-gateway.yaml
kubectl apply -f ./resources/other/dashboard-adminuser.yaml
kubectl apply -f ./resources/secrets/kiali.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml

for namespace in ${NAMESPACES[@]}; do
  # Enable automatic Istio sidecar injection
  kubectl label namespace ${namespace} istio-injection=enabled

  kubectl apply -n ${namespace} -f ./resources/secrets/go-srv-demo.yaml
  
  kubectl apply -n ${namespace} -f ./resources/other/external-mesh-mongodb-atlas.yaml
  
  kubectl apply -n ${namespace} -f ./resources/other/external-mesh-cloudamqp.yaml

  for service in ${SERVICES[@]}; do
    kubectl apply -n ${namespace} -f ./resources/services/service-$service.yaml
  done
  kubectl apply -n ${namespace} -f ./resources/services/angular-ui.yaml
done
