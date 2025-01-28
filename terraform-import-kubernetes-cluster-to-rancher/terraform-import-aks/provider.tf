terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "6.0.0"
    }
  }
}

provider "rancher2" {
  api_url    = "https://rancher.singhritesh85.com"
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
}
