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

echo "Using KUBECONFIG: $KUBECONFIG"
# Infinite loop
while true; do
  # Check if the Kubernetes cluster is active
  if kubectl cluster-info; then
    echo "Kubernetes cluster is active."
    
    # If the cluster is active, break the loop
    break
  else
    echo "Kubernetes cluster is not active."
  fi

  # Wait for 10 seconds before the next check
  sleep 10
done

echo "..."
echo "############################################"
echo "Creating namespace cert-manager"
echo "############################################"
kubectl create namespace cattle-system
if [ $? -eq 0 ]; then
  echo "The command was executed successfully"
else
  echo "The command failed"
  exit 1
fi

echo "..."
echo "############################################"
echo "Installing cert-manager"
echo "############################################"
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v${cert_manager_version}/cert-manager.crds.yaml
if [ $? -eq 0 ]; then
  echo "The command was executed successfully"
else
  echo "The command failed"
  exit 1
fi

echo "..."
echo "############################################"
echo "Adding the Rancher Helm repository"
echo "############################################"
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
if [ $? -eq 0 ]; then
  echo "The command was executed successfully"
else
  echo "The command failed"
  exit 1
fi

echo "..."
echo "############################################"
echo "Adding the Jetstack Helm repository"
echo "############################################"
helm repo add jetstack https://charts.jetstack.io
if [ $? -eq 0 ]; then
  echo "The command was executed successfully"
else
  echo "The command failed"
  exit 1
fi

echo "..."
echo "############################################"
echo "Installing cert-manager using Helm"
echo "############################################"
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version ${cert_manager_version}
if [ $? -eq 0 ]; then
  echo "The command was executed successfully"
else
  echo "The command failed"
  exit 1
fi

echo "..."
echo "############################################"
echo "Installing rancher using Helm"
echo "############################################"
helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=$hostname --set replicas=$replicas --set bootstrapPassword=$bootstrapPassword --version ${rancher_version}
if [ $? -eq 0 ]; then
  echo "The command was executed successfully"
else
  echo "The command failed"
  exit 1
fi
