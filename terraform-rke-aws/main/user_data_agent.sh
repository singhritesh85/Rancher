#!/bin/bash

################################# Create a user named ritesh ####################################

/usr/sbin/useradd -s /bin/bash -m ritesh;
mkdir /home/ritesh/.ssh;
chmod -R 700 /home/ritesh;
echo "ssh-rsa XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ritesh@DESKTOP-0XXXXXX" >> /home/ritesh/.ssh/authorized_keys;
chmod 600 /home/ritesh/.ssh/authorized_keys;
chown ritesh:ritesh /home/ritesh/.ssh -R;
sudo echo "ritesh  ALL=(ALL)  NOPASSWD:ALL" > /etc/sudoers.d/ritesh;
sudo chmod 440 /etc/sudoers.d/ritesh;

############################ Download jq #########################################################

sudo wget https://github.com/mikefarah/yq/releases/download/v4.45.1/yq_linux_amd64 -O /usr/bin/yq && sudo chmod +x /usr/bin/yq

###################### Install Docker on All the RKE Servers and RKE Agents ######################

sudo apt-get update
sudo apt-get install -y docker.io && sudo systemctl start docker && sudo systemctl enable docker
sudo usermod -a -G docker ritesh

################################# Disable swap ##################################################

sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

#################################### Install awscli #############################################

sudo apt-get install -y unzip
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
aws --version

aws s3 cp s3://dexter-medermatherema/cluster.yaml ./

HOSTNAME=`ip addr | grep "ens5"| grep "inet" | cut -d "/" -f 1 | tr -d "inet "` NUMBER_OF_NODES="$(yq eval '.nodes|length' cluster.yaml)" yq eval -i '.nodes[env(NUMBER_OF_NODES)].address = env(HOSTNAME) | .nodes[env(NUMBER_OF_NODES)].user = "ritesh" | .nodes[env(NUMBER_OF_NODES)].role[0] = "worker"' ./cluster.yaml

# Upload the cluster.yaml file to the S3 bucket
aws s3 cp ./cluster.yaml s3://dexter-medermatherema
