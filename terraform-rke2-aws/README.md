#### To create the Infrastructure for K3S Cluster #########

1. Provide the kms_key_id of your AWS Account to encrypt the EBS in terraform.tfvars.
2. Provide Public key in user_data.sh

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
