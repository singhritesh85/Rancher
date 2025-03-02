#### To create the Infrastructure for K3S Cluster #########

1. Provide the kms_key_id of your AWS Account to encrypt the EBS in terraform.tfvars.
2. Provide the monitoring_role_arn in the file terraform.tfvars.
3. Provide the kms_key_id_rds in the file terraform.tfvars.
4. Provide Public key in user_data.sh

### K3S HA Cluster with etcd as cluster datastore 
```
curl -sfL https://get.k3s.io | sh -s - server --cluster-init --tls-san=network-loadbalancer-k3s-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com:6443   -----> On First Master

cat /var/lib/rancher/k3s/server/node-token   --------------> Get the K3S Token from this command

curl -sfL https://get.k3s.io | K3S_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX sh -s - server --server https://10.XX.X.198:6443 --tls-san=network-loadbalancer-k3s- XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com  ----> On second and third master
 
curl -sfL https://get.k3s.io | K3S_TOKEN= XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX sh -s - agent --server https://network-loadbalancer-k3s- XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com:6443    ----------------> To be run on all the Agents
```
![image](https://github.com/user-attachments/assets/b136e7d8-1d66-41de-8508-4d64582b1f00)

As shown in the architecture diagram for K3S HA cluster drawn above I had taken three masters (K3S Servers) and three nodes (K3S Agents). The etcd was treated as the cluster datastore. I had used a Network LoadBalancer in front of all the three K3S Servers as shown in the diagram drawn above to provide high availability.

![image](https://github.com/user-attachments/assets/8b076760-2061-458b-8b42-90000ff5b24d)

### K3S HA Cluster with PostgreSQL RDS as cluster datastore 
```
curl -sfL https://get.k3s.io | sh -s - server --cluster-init --datastore-endpoint="postgres://postgres:XXXXXXXX@dbinstance-1.XXXXXXXXXXXX.us-east-2.rds.amazonaws.com/mydb" --tls-san=network-loadbalancer-k3s-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com:6443   -----> On First Master

cat /var/lib/rancher/k3s/server/node-token   --------------> Get the K3S Token from this command

curl -sfL https://get.k3s.io | K3S_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX sh -s - server --server https://10.XX.X.198:6443 --datastore-endpoint="postgres://postgres:XXXXXXXX@dbinstance-1.XXXXXXXXXXXX.us-east-2.rds.amazonaws.com/mydb"  --tls-san=network-loadbalancer-k3s- XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com  ----> On second and third master
 
curl -sfL https://get.k3s.io | K3S_TOKEN= XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX sh -s - agent --server https://network-loadbalancer-k3s- XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com:6443    ----------------> To be run on all the Agents
```
IP Address 10.XX.X.198 is the Private IP Address of first Master.

![image](https://github.com/user-attachments/assets/9d78727d-79c3-45d4-8471-b75839fd4b6d)

In the K3S HA (high availability) cluster configuration, each node registers with the Kubernetes API by using a fixed registration address (Network LoadBalancer). After registration, the agent nodes established a connection directly to one of the server nodes, as shown in the diagram above.

![image](https://github.com/user-attachments/assets/abd6ce88-69a3-4586-a7b9-692654c145c8)
