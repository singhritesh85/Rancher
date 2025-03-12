# Create a cluster with multiple machine pools
resource "rancher2_cluster_v2" "rke2_machine_pools" {
  name = "rke2-downstream-cluster"
  kubernetes_version = var.kubernetes_version     ###"v1.30.5+rke2r2"
  enable_network_policy = false
  local_auth_endpoint {
    enabled = false
  }
  rke_config {
    # Nodes in this pool have control plane role and etcd roles
    machine_pools {
      name = "pool1"
      cloud_credential_secret_name = rancher2_cloud_credential.aws_cloud_cred.id
      control_plane_role = true
      etcd_role = true
      worker_role = false
      quantity = 1
      drain_before_delete = true
      machine_config {
        kind = rancher2_machine_config_v2.rke_ec2.kind
        name = rancher2_machine_config_v2.rke_ec2.name
      }
    }
    # Each machine pool must be passed separately
    # Nodes in this pool have only the worker role
    machine_pools {
      name = "pool2"
      cloud_credential_secret_name = rancher2_cloud_credential.aws_cloud_cred.id
      control_plane_role = false
      etcd_role = false
      worker_role = true
      quantity = 1
      drain_before_delete = true
      machine_config {
        kind = rancher2_machine_config_v2.rke_ec2.kind
        name = rancher2_machine_config_v2.rke_ec2.name
      }
    }
#    machine_selector_config {
#      config = {
#        cloud-provider-name = ""
#      }
#    }
    machine_global_config = <<EOF
      cni: "calico"
    EOF
    upgrade_strategy {
      control_plane_concurrency = "10%"
      worker_concurrency = "10%"
    }
    etcd {
      snapshot_schedule_cron = "0 */5 * * *"
      snapshot_retention = 5
    }
  }
  depends_on = [rancher2_machine_config_v2.rke_ec2]
}

# Kubeconfig file
resource "local_file" "rke2_kubeconfig" {
  filename = "${path.module}/.kube/config"
  content = rancher2_cluster_v2.rke2_machine_pools.kube_config
  file_permission = "0600"

}
