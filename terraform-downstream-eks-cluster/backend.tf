terraform {
  backend "s3" {
    bucket = "dolo-dempo"
    key    = "downstream-rancher-eks/terraform.tfstate"
    region = "us-east-2"
  }

  required_providers {
    local = {
      source = "hashicorp/local"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "8.0.0"
    }
  }
}
