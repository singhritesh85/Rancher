#### To create the Infrastructure for K3S Cluster #########

1. Provide the kms_key_id of your AWS Account to encrypt the EBS in terraform.tfvars.
2. Provide the monitoring_role_arn in the file terraform.tfvars.
3. Provide the kms_key_id_rds in the file terraform.tfvars.
4. Provide Public key in user_data.sh

```
curl -sfL https://get.k3s.io | sh -s - server --cluster-init --datastore-endpoint="postgres://postgres:XXXXXXXX@dbinstance-1.XXXXXXXXXXXX.us-east-2.rds.amazonaws.com/mydb" --tls-san=network-loadbalancer-k3s-XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com:6443   -----> On First Master

cat /var/lib/rancher/k3s/server/node-token   --------------> Get the K3S Token from this command

curl -sfL https://get.k3s.io | K3S_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX sh -s - server --server https://10.XX.X.198:6443 --datastore-endpoint="postgres://postgres:XXXXXXXX@dbinstance-1.XXXXXXXXXXXX.us-east-2.rds.amazonaws.com/mydb"  --tls-san=network-loadbalancer-k3s- XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com  ----> On second and third master
 
curl -sfL https://get.k3s.io | K3S_TOKEN= XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX::server:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX sh -s - agent --server https://network-loadbalancer-k3s- XXXXXXXXXXXXXXXX.elb.us-east-2.amazonaws.com:6443    ----------------> To be run on all the Agents
```
