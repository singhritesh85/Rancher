#### To create the Infrastructure for RKE Cluster #########
```
1. Provide the kms_key_id of your AWS Account to encrypt the EBS in terraform.tfvars.
2. Provide Public key in the file user_data_agent.sh, user_data_jumpbox.sh and user_data_server.sh.
```
In this section to create the RKE cluster I used a terraform script which is present in my GitHub Repo https://github.com/singhritesh85/Rancher.git. The RKE cluster had three masters (RKE Servers) and three worker nodes (RKE Agents). To create the RKE Cluster using the Terraform I created a s3 bucket named as dexter-medermatherema and in this s3 bucket I kept the cluster.yaml (configuration file to create the RKE Cluster) and SSH private key to login into the RKE Servers and Agents. Finally, I created the RKE Cluster as shown in the screenshot attached below.

![image](https://github.com/user-attachments/assets/1600b6aa-baf1-42fa-88cc-d4849baf8adc)
![image](https://github.com/user-attachments/assets/6f4fcfcf-5b4d-43f5-b18c-3361f494ea47)
 
As discussed above I kept the SSH private key in the s3 bucket, I created the SSH keys (Private and Public Key) using the command **ssh-keygen -t rsa -b 2048** as shown in the screenshot attached below. 
 
![image](https://github.com/user-attachments/assets/6ae027a6-765c-4948-b8fd-5289cfd3db99)
