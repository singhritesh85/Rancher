#### To create the Infrastructure for RKE2 Cluster #########
```
1. Provide the kms_key_id of your AWS Account to encrypt the EBS in terraform.tfvars.
2. Provide Public key in user_data.sh
```
I had explained here how to create HA (high availability) RKE2 Cluster. In this cluster I used three Kubernetes Masters (RKE2 Servers) and three Kubernetes Workers/Nodes (RKE2 Agents). I used a Network LoadBalancer as a fixed registration address. The Aws Resources (EC2 Instances, Autoscaling Group, Launch Template, Security Group and LoadBalancer) which was being used in this RKE2 Cluster had been created using the terraform. The Terraform script is available in this GitHub Repository.    
The fixed registration address had been used in front of RKE2 server nodes which allow other RKE2 nodes to register with RKE2 Cluster.

![image](https://github.com/user-attachments/assets/f5061586-3bee-4379-8389-154dd69083b6)

### Creation of RKE2 HA Cluster  
```
===================================================================================================================
On first master run below commands
===================================================================================================================
curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.30.5+rke2r1  sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service

cat /var/lib/rancher/rke2/server/node-token   ----------------->  Get the node token 

vim /etc/rancher/rke2/config.yaml

token: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
tls-san:
  - network-loadbalancer-rke2-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com

systemctl restart rke2-server.service
systemctl status rke2-server.service

cp /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/  ------>  Copy kubectl to /usr/local/bin 
mkdir ~/.kube
cp /etc/rancher/rke2/rke2.yaml .kube/config  --------------->  Copy generated kubeconfig file
===================================================================================================================
===================================================================================================================
On second master and third master run below commands
===================================================================================================================

curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.30.5+rke2r1  sh -
mkdir -p /etc/rancher/rke2

vim /etc/rancher/rke2/config.yaml

server: https://10.XX.X.178:9345
token: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
tls-san:
  - network-loadbalancer-rke2-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com

systemctl enable rke2-server.service
systemctl start rke2-server.service
====================================================================================================================
====================================================================================================================

On worker nodes run below commands
====================================================================================================================

curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.30.5+rke2r1 INSTALL_RKE2_TYPE="agent" sh -
systemctl enable rke2-agent.service
mkdir -p /etc/rancher/rke2/

vim /etc/rancher/rke2/config.yaml

server: https://10.XX.X.178:9345
token: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

systemctl start rke2-agent.service
```

Where IP Address 10.XX.X.178 is the IP Address of first RKE2 Server and network-loadbalancer-rke2-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com is the DNS Name of the Network LoadBalancer which was used as a fixed registration address.

![image](https://github.com/user-attachments/assets/94d24361-5631-4796-99c2-03d6af14d905)

