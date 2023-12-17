#!/bin/sh

if [ $# -ne 3 ]; then
    echo "Usage: $0 <kube_api_server_worker> <ks3_version> <ks3_token>"
    exit 1
fi

KUBE_API_SERVER_WORKER=$1
K3S_VERSION=$2
K3S_TOKEN_ARG=$3

echo "."
echo "Installing KS3 worker node..."
while ! curl --insecure https://$KUBE_API_SERVER_WORKER:6443; do
    echo "."
    echo "K3S API server WORKER ($KUBE_API_SERVER_WORKER) not responding."
    echo "Waiting 10 seconds before we try again."
    sleep 10
done
echo "."
echo "K3S API server controleplane ($KUBE_API_SERVER_WORKER) appears to be up."
echo "."
echo "Installing KS3 worker node..."
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" K3S_URL=https://$KUBE_API_SERVER_WORKER:6443 K3S_TOKEN=$K3S_TOKEN_ARG sh -
