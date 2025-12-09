terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "8.0.0"
    }
  }
}

provider "rancher2" {
  api_url    = var.api_url 
  token_key = var.rancher_token
}

provider "azurerm" {
  client_id = var.client_id
  client_secret = var.client_secret
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id

  features {}
}
