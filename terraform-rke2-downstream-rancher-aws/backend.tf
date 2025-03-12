terraform {
  backend "s3" {
    bucket         = "dolo-dempo"
    key            = "state/rancher/rke2/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-state"
  }

  required_providers {
    local = {
      source = "hashicorp/local"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "6.0.0"
    }
  }
}
