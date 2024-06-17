#!/bin/bash

# Mettre à jour le système
sudo apt update && sudo apt upgrade -y

# Installer les outils de développement
sudo apt install -y git curl wget build-essential

# Vérifier l'installation des outils de développement
if ! command -v git &> /dev/null || ! command -v curl &> /dev/null || ! command -v wget &> /dev/null; then
    echo "Erreur lors de l'installation des outils de développement."
    exit 1
fi

# Installer Docker
sudo apt install -y apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Vérifier l'installation de Docker
if ! command -v docker &> /dev/null; then
    echo "Erreur lors de l'installation de Docker."
    exit 1
fi

# Installer Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '(?<=tag_name\": \"v)[^"]*')" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Vérifier l'installation de Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Erreur lors de l'installation de Docker Compose."
    exit 1
fi

# Installer Terraform
sudo apt install -y unzip
wget https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_amd64.zip
sudo unzip terraform_1.3.7_linux_amd64.zip -d /usr/local/bin/
rm terraform_1.3.7_linux_amd64.zip

# Vérifier l'installation de Terraform
if ! command -v terraform &> /dev/null; then
    echo "Erreur lors de l'installation de Terraform."
    exit 1
fi

# Installer Ansible
sudo apt update
sudo apt install -y ansible

# Vérifier l'installation d'Ansible
if ! command -v ansible &> /dev/null; then
    echo "Erreur lors de l'installation d'Ansible."
    exit 1
fi

# Installer Python et pip
sudo apt install -y python3 python3-pip python3-venv

# Créer un environnement virtuel pour installer les paquets Python
python3 -m venv ~/myenv
source ~/myenv/bin/activate

# Installer les dépendances Python pour le développement
pip install flask django requests

# Vérifier l'installation des paquets Python
if ! python -c "import flask, django, requests" &> /dev/null; then
    echo "Erreur lors de l'installation des paquets Python."
    exit 1
fi

# Installer Kubernetes CLI (kubectl)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Vérifier l'installation de kubectl
if ! command -v kubectl &> /dev/null; then
    echo "Erreur lors de l'installation de kubectl."
    exit 1
fi

# Installer AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

# Vérifier l'installation de l'AWS CLI
if ! command -v aws &> /dev/null; then
    echo "Erreur lors de l'installation de l'AWS CLI."
    exit 1
fi

# Configuration de l'utilisateur pour AWS CLI
aws configure

echo "Installation des prérequis terminée. Veuillez redémarrer la machine pour appliquer les changements de groupe Docker."
sleep 10
# Redémarrer la machine
sudo reboot
