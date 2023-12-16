#!/bin/bash

# Check if the helm keyring file already exists
if [ ! -f /usr/share/keyrings/helm.gpg ]; then
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
fi

sudo apt-get install apt-transport-https --yes

# Check if the Helm list already exists
if ! grep -q "https://baltocdn.com/helm/stable/debian/" /etc/apt/sources.list.d/helm-stable-debian.list; then
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
fi

sudo apt-get update
sudo apt-get install helm
sudo helm version --client