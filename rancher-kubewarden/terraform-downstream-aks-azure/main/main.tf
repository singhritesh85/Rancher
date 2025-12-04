module "aks" {

  source = "../module"
  prefix = var.prefix
  location = var.location[1]
  kubernetes_version = var.kubernetes_version[13]
  ssh_public_key = var.ssh_public_key
  action_group_shortname = var.action_group_shortname
  email_address = var.email_address

  env = var.env[0]
}

