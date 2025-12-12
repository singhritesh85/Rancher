#### To create the Infrastructure for RKE2 Cluster #########
```
1. Provide the kms_key_id of your AWS Account to encrypt the EBS in terraform.tfvars.
2. Provide Public key in user_data.sh
```
I had explained here how to create HA (high availability) RKE2 Cluster. In this cluster I used three Kubernetes Masters (RKE2 Servers) and three Kubernetes Workers/Nodes (RKE2 Agents). I used a Network LoadBalancer as a fixed registration address. The Aws Resources (EC2 Instances, Autoscaling Group, Launch Template, Security Group and LoadBalancer) which was being used in this RKE2 Cluster had been created using the terraform. The Terraform script is available in this GitHub Repository.    
The fixed registration address had been used in front of RKE2 server nodes which allow other RKE2 nodes to register with RKE2 Cluster.

<img width="860" height="473" alt="image" src="https://github.com/user-attachments/assets/24bc1537-f7b6-434e-8039-a8cae0a0b0f3" />

### Creation of RKE2 HA Cluster  
```
===================================================================================================================
On first master run below commands
===================================================================================================================
curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.33.6+rke2r1  sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service

cat /var/lib/rancher/rke2/server/node-token   ----------------->  Get the node token 

vim /etc/rancher/rke2/config.yaml

token: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
tls-san:
  - nlb-rke2-internal-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com
  - nlb-rke2-external-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com

systemctl restart rke2-server.service
systemctl status rke2-server.service

cp /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/  ------>  Copy kubectl to /usr/local/bin 
mkdir ~/.kube
cp /etc/rancher/rke2/rke2.yaml .kube/config  --------------->  Copy generated kubeconfig file
===================================================================================================================
===================================================================================================================
On second master and third master or on new masters created using the RKE2 Server ASG run below commands
===================================================================================================================

curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.33.6+rke2r1  sh -
mkdir -p /etc/rancher/rke2

vim /etc/rancher/rke2/config.yaml

server: https://nlb-rke2-internal-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws:9345
token: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
tls-san:
  - nlb-rke2-internal-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com
  - nlb-rke2-external-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com

systemctl enable rke2-server.service
systemctl start rke2-server.service
====================================================================================================================
====================================================================================================================

On worker nodes or on new worker nodes created using RKE2 Agent ASG run below commands
====================================================================================================================

curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.33.6+rke2r1 INSTALL_RKE2_TYPE="agent" sh -
systemctl enable rke2-agent.service
mkdir -p /etc/rancher/rke2/

vim /etc/rancher/rke2/config.yaml

server: https://nlb-rke2-internal-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com:9345
token: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

systemctl start rke2-agent.service
```

Where nlb-rke2-internal-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com is the DNS Name of the Internal Network LoadBalancer which was used as a fixed registration address and nlb-rke2-external-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com is the DNS Name of the External Network LoadBalancer which was used to route external user’s request. 

<img width="1243" height="205" alt="image" src="https://github.com/user-attachments/assets/2272874b-2fa7-49ae-afff-43d90ba08bc6" />

**AWS External Network LoadBalancer will route the traffic received on port 80 and 443 to target group containing RKE2 agents, and will route the traffic recieved on 6443 (API Server Traffic) to target group containing RKE2 Servers. Port 80 and 443 used for workloads running in the RKE2 Clusters and that is the reason traffic had been routed to the RKE2 Cluster agents (Kubernetes Cluster Worker Nodes). As per the standard practice Kubernetes Workloads are running on the Kubernetes Worker Nodes, however if you are also running the Kubernetes Workloads on the Kubernetes Master Nodes (RKE2 Servers) then in target group for port 80 and 443 include RKE2 Servers as well.**    

