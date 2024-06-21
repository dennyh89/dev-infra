terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    # google = {
    #   source  = "hashicorp/google"
    #   version = "~> 5.32.0"
    # }
   
  }
}

provider "azurerm" {
  features {}
  subscription_id = "2fc0173e-cada-4000-82db-566c79d396db"
}












#####
# GKE
#####

# # gcloud auth application-default login
# provider "google" {
#   project = var.project_id
#   region  = var.region
# }


# data "google_client_config" "current" {}
# provider "kubernetes" {
#   host                   = "https://${google_container_cluster.test-cluster-1.endpoint}"
#   token                  = data.google_client_config.current.access_token

#   cluster_ca_certificate = base64decode(google_container_cluster.test-cluster-1.master_auth[0].cluster_ca_certificate)
# }


# provider "kubectl" {
#   host                   = "https://${google_container_cluster.test-cluster-1.endpoint}"
#   token                  = data.google_client_config.current.access_token
#   load_config_file = false
#   cluster_ca_certificate = base64decode(google_container_cluster.test-cluster-1.master_auth[0].cluster_ca_certificate)
# }
