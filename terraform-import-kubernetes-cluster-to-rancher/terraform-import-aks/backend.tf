terraform {
  backend "azurerm" {
    resource_group_name  = "ritesh"
    storage_account_name = "terraformstate08022024"
    container_name       = "terraform-state"
    key                  = "aks-downstream-1-import/terraform.tfstate"
  }
}
