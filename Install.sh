#!/bin/bash

set -e

echo "Mise à jour du système..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Installation de Git..."
sudo apt-get install -y git

echo "Installation de Docker..."
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

echo "Installation de Terraform..."
wget https://releases.hashicorp.com/terraform/1.1.3/terraform_1.1.3_linux_amd64.zip
unzip terraform_1.1.3_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_1.1.3_linux_amd64.zip

echo "Installation d'Ansible..."
sudo apt-get install -y software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

echo "Installation de l'AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

echo "Ajout du dépôt Kubernetes..."
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

echo "Installation de kubelet, kubeadm et kubectl..."
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "Désactivation du swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "Initialisation du cluster Kubernetes..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

echo "Configuration de kubectl pour l'utilisateur actuel..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Déploiement du réseau Calico..."
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo "Installation de Helm..."
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

echo "Installation de Prometheus et Grafana avec Helm..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus
helm install grafana grafana/grafana

echo "Installation terminée !"
