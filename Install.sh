#!/bin/bash

# Mise à jour des paquets et installation des prérequis
echo "Mise à jour des paquets et installation des prérequis..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Installation de Terraform
echo "Installation de Terraform..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update -y
sudo apt-get install -y terraform

# Installation de AWS CLI
echo "Installation de AWS CLI..."
sudo apt-get install -y awscli

# Installation de Docker
echo "Installation de Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce

# Ajout de l'utilisateur actuel au groupe Docker
sudo usermod -aG docker ${USER}

# Installation de Minikube
echo "Installation de Minikube..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube /usr/local/bin/

# Installation de kubectl
echo "Installation de kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install kubectl /usr/local/bin/

# Installation de Python, pip, et virtualenv
echo "Installation de Python, pip, et virtualenv..."
sudo apt-get install -y python3 python3-pip python3-venv

# Installation de Java
echo "Installation de Java..."
sudo apt-get install -y default-jdk

# Configuration de JAVA_HOME
echo "Configuration de JAVA_HOME..."
JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
source ~/.bashrc

# Installation de Git
echo "Installation de Git..."
sudo apt-get install -y git

# Installation de Prometheus
echo "Installation de Prometheus..."
sudo useradd --no-create-home --shell /bin/false prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.29.1/prometheus-2.29.1.linux-amd64.tar.gz
tar xvf prometheus-2.29.1.linux-amd64.tar.gz
sudo cp prometheus-2.29.1.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.29.1.linux-amd64/promtool /usr/local/bin/
sudo mkdir /etc/prometheus
sudo cp -r prometheus-2.29.1.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.29.1.linux-amd64/console_libraries /etc/prometheus
sudo cp prometheus-2.29.1.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml

# Installation de Grafana
echo "Installation de Grafana..."
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt-get update -y
sudo apt-get install -y grafana
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

echo "Installation terminée ! Veuillez redémarrer votre session ou exécuter 'newgrp docker' pour appliquer les changements de groupe Docker."

# Nettoyage des fichiers téléchargés
rm -f minikube kubectl prometheus-2.29.1.linux-amd64.tar.gz

# Instructions finales
echo "Tous les outils nécessaires ont été installés. Assurez-vous de configurer AWS CLI avec 'aws configure'."
