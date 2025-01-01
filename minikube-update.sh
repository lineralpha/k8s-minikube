#!/bin/bash

# minikube update script
minikube delete --all --purge && \
sudo rm -rf /usr/local/bin/minikube && \
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
chmod +x minikube && \
sudo cp minikube /usr/local/bin/ && \
rm minikube

# or, use the following commands to download and install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

#  install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# Certificates Section
# Get RootCA via HTTP
curl -O http://certs.blueorigin.com/BlueOriginRootCA.crt
sudo mv -f BlueOriginRootCA.crt /usr/local/share/ca-certificates
update-ca-certificates

# Get other certs via HTTPS
curl -O https://certs.blueorigin.com/BlueOriginServerIssuingCA.crt
curl -O https://certs.blueorigin.com/BlueOriginWebsiteIssuingCA.crt
curl -O https://certs.blueorigin.com/BlueOriginDeviceIssuingCA.crt

sudo mv -f BlueOriginDeviceIssuingCA.crt /usr/local/share/ca-certificates/
sudo mv -f BlueOriginWebsiteIssuingCA.crt /usr/local/share/ca-certificates/
sudo mv -f BlueOriginServerIssuingCA.crt /usr/local/share/ca-certificates/

update-ca-certificates
# Certs are good

install minikube on windows

New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing

