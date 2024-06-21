terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.32.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4.3"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = ">= 0.9.6"
    }
  }
}

data "terraform_remote_state" "clusters" {
  backend = "azurerm"
  config = {
    resource_group_name   = "tfstate"
    storage_account_name  = "tfstate15556"
    container_name        = "tfstate"
    key                   = "clusters.terraform.tfstate"
  }
}

locals {
  kube_config_one = yamldecode(data.terraform_remote_state.clusters.outputs.cluster_one)
  kube_config_two = yamldecode(data.terraform_remote_state.clusters.outputs.cluster_two)
}

# provider "kubernetes" {
#   host                   = data.azurerm_kubernetes_cluster.default.kube_config.0.host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)
# }

provider "kubectl" {
  host                   = local.kube_config_one.clusters.0.cluster.server
  client_certificate     = base64decode(local.kube_config_one.users.0.user.client-certificate-data)
  client_key             = base64decode(local.kube_config_one.users.0.user.client-key-data)
  cluster_ca_certificate = base64decode(local.kube_config_one.clusters.0.cluster.certificate-authority-data)
  load_config_file = false
}

provider "kustomization" {

  kubeconfig_raw = data.terraform_remote_state.clusters.outputs.cluster_one
}



#
# Cluster two
#


# provider "kubernetes" {
#   host                   = data.azurerm_kubernetes_cluster.default.kube_config.0.host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)
# }

provider "kubectl" {
  host                   = local.kube_config_two.clusters.0.cluster.server
  client_certificate     = base64decode(local.kube_config_two.users.0.user.client-certificate-data)
  client_key             = base64decode(local.kube_config_two.users.0.user.client-key-data)
  cluster_ca_certificate = base64decode(local.kube_config_two.clusters.0.cluster.certificate-authority-data)
  load_config_file = false
  alias = "cluster-two"
}

provider "kustomization" {

  kubeconfig_raw = data.terraform_remote_state.clusters.outputs.cluster_two
  alias = "cluster-two"
}

