############################################## Variables for AKS Cluster ##################################################

client_id = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
client_secret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
subscription_id = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
tenant_id = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
resource_group = "dexter-rg"
node_resource_group = "dexter-nodegroup-rg"
resource_location = ["East US", "East US 2", "Central India", "Central US"]
dns_prefix = "dexter-cluster-dns"
kubernetes_version = ["1.28.3", "1.28.5", "1.29.0", "1.29.2", "1.29.9", "1.29.13", "1.30.5", "1.30.9", "1.31.2", "1.31.5", "1.32.0"]
network_plugin = "kubenet"
network_service_cidr = "10.0.0.0/16"
network_dns_service_ip = "10.0.0.10"
os_disk_type = "Managed"
orchestrator_version = ["1.28.3", "1.28.5", "1.29.0", "1.29.2", "1.29.9", "1.29.13", "1.30.5", "1.30.9", "1.31.2", "1.31.5", "1.32.0"]
os_disk_size_gb = 32
max_pods = 110
vm_size = "Standard_B2s"
api_url = "https://rancher.singhritesh85.com/"
rancher_token = "token-XXXXX:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
