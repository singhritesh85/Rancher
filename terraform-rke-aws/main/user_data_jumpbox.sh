#!/bin/bash

################################# Create a user named ritesh ####################################

/usr/sbin/useradd -s /bin/bash -m ritesh;
mkdir /home/ritesh/.ssh;
chmod -R 700 /home/ritesh;
echo "ssh-rsa XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ritesh@DESKTOP-0XXXXXX" >> /home/ritesh/.ssh/authorized_keys;
chmod 600 /home/ritesh/.ssh/authorized_keys;
chown ritesh:ritesh /home/ritesh/.ssh -R;
sudo echo "ritesh  ALL=(ALL)  NOPASSWD:ALL" > /etc/sudoers.d/ritesh;
sudo chmod 440 /etc/sudoers.d/ritesh;

############################ Download RKE Binary #################################################

sudo wget https://github.com/rancher/rke/releases/download/v1.7.3/rke_linux-amd64
sudo mv ./rke_linux-amd64 ./rke
sudo chmod +x ./rke 

#################################### Install awscli #############################################

sudo apt-get install -y unzip
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
aws --version

sudo aws s3 cp s3://dexter-medermatherema/cluster.yaml ./
sudo aws s3 cp s3://dexter-medermatherema/id_rsa.txt ./id_rsa
sudo chmod 600 ./id_rsa

sudo ./rke up --config ./cluster.yaml

################################### Install kubectl and helm ###################################

sudo curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin
sudo curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 -o get_helm.sh
sudo chmod 700 get_helm.sh
sudo DESIRED_VERSION=v3.8.0 ./get_helm.sh
sudo mkdir ~/.kube 
sudo cp ./kube_config_cluster.yaml ~/.kube/config
