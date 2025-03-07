#### To create the Infrastructure for K3S Cluster #########
```
1. Provide the kms_key_id of your AWS Account to encrypt the EBS in terraform.tfvars.
2. Provide Public key in the file user_data_agent.sh, user_data_jumpbox.sh and user_data_server.sh.
```
I had explained here how to create HA (high availability) RKE Cluster. In this cluster I used three Kubernetes Masters (RKE Servers) and three Kubernetes Workers/Nodes (RKE Agents). I used a Network LoadBalancer as a fixed registration address. The Aws Resources (EC2 Instances, Autoscaling Group, Launch Template, Security Group and LoadBalancer) which was being used in this RKE Cluster had been created using the terraform. The Terraform script is available in this GitHub Repository.    
The fixed registration address had been used in front of RKE server nodes which allow other RKE nodes to register with RKE Cluster.

![image](https://github.com/user-attachments/assets/f5061586-3bee-4379-8389-154dd69083b6)

To create the RKE Cluster using the Terraform I created a s3 bucket named as dexter-medermatherema and in this s3 bucket I kept the cluster.yaml (configuration file to create the RKE Cluster) and SSH private key to login into the RKE Servers and Agents. Finally, I created the RKE Cluster as shown in the screenshot attached below.

![image](https://github.com/user-attachments/assets/94d24361-5631-4796-99c2-03d6af14d905)

