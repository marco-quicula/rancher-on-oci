#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 6 ]; then
    echo "Usage: $0 <kubeconfig> <cert_manager_version> <rancher_version> <hostname> <replicas> <bootstrapPassword>"
    exit 1
fi

kubeconfig=$1
cert_manager_version=$2
rancher_version=$3
hostname=$4
replicas=$5
bootstrapPassword=$6

export KUBECONFIG=$kubeconfig

kubectl create namespace cattle-system
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v${cert_manager_version}/cert-manager.crds.yaml

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version ${cert_manager_version}
helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=$hostname --set replicas=$replicas --set bootstrapPassword=$bootstrapPassword --version ${rancher_version}