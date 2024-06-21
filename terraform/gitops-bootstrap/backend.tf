terraform {
  backend "azurerm" {
    resource_group_name   = "tfstate"
    storage_account_name  = "tfstate15556"
    container_name        = "tfstate"
    key                   = "gitops-bootstrap.terraform.tfstate"
  }
}