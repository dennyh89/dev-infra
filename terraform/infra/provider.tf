terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
   
  }
}

provider "azurerm" {
  features {}
  subscription_id = "2fc0173e-cada-4000-82db-566c79d396db"
}