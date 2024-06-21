locals {
  location = "northeurope"
  location2 = "germanywestcentral"
  prefix_name= "dehe"
  nodecount = 2
  min_tags= {
    "author" =local.prefix_name
    "purpose" = "devopschallenge"
  }
  
}

resource "azurerm_resource_group" "one" {
  location = local.location
  name     = local.prefix_name
  tags = local.min_tags
}

resource "azurerm_kubernetes_cluster" "one" {
  location            = azurerm_resource_group.one.location
  name                = "${local.prefix_name}-cluster-1"
  resource_group_name = azurerm_resource_group.one.name
  dns_prefix          = "${local.prefix_name}-cluster-1"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = local.nodecount
  }
  # linux_profile {
  #   admin_username = var.username

  #   ssh_key {
  #     key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  #   }
  # }

  # TODO: rethink if switch to azure cni
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  tags = local.min_tags
}



resource "azurerm_resource_group" "two" {
  location = local.location2
  name     = "${local.prefix_name}-2"
  tags = local.min_tags
}

resource "azurerm_kubernetes_cluster" "two" {
  location            = azurerm_resource_group.two.location
  name                = "${local.prefix_name}-cluster-2"
  resource_group_name = azurerm_resource_group.two.name
  dns_prefix          = "${local.prefix_name}-cluster-2"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = local.nodecount
  }
  # linux_profile {
  #   admin_username = var.username

  #   ssh_key {
  #     key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  #   }
  # }

  # TODO: rethink if switch to azure cni
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  tags = local.min_tags
}


data "azurerm_kubernetes_cluster" "one" {
  name                = azurerm_kubernetes_cluster.one.name
  resource_group_name = azurerm_kubernetes_cluster.one.resource_group_name
}

data "azurerm_kubernetes_cluster" "two" {
  name                = azurerm_kubernetes_cluster.two.name
  resource_group_name = azurerm_kubernetes_cluster.two.resource_group_name
}


resource "azurerm_public_ip" "static_ip_1" {
  name                = "static-ip"
  location            = data.azurerm_kubernetes_cluster.one.location
  resource_group_name = data.azurerm_kubernetes_cluster.one.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label = "cluster-1-randomdomain"
   tags = local.min_tags
}

resource "azurerm_public_ip" "static_ip_2" {
  name                = "static-ip"
  location            = data.azurerm_kubernetes_cluster.two.location
  resource_group_name = data.azurerm_kubernetes_cluster.two.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label = "cluster-2-randomdomain"
  tags = local.min_tags
}


# create azure traffic manager
resource "azurerm_resource_group" "router" {
  name     = "global-router"
  location = local.location
  tags = local.min_tags
}

resource "azurerm_traffic_manager_profile" "clusters" {
  name                = "clusters-tm-profile"
  resource_group_name = azurerm_resource_group.router.name


  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = "clusters-tm-profile"
    ttl           = 30
  }
  
  monitor_config {
    port = 80
    protocol = "HTTP"
    path = "/hello"
  }

   tags = local.min_tags
}

resource "azurerm_traffic_manager_azure_endpoint" "one" {
  name                = "one"
  profile_id =          azurerm_traffic_manager_profile.clusters.id
  always_serve_enabled = true

  target_resource_id  = azurerm_public_ip.static_ip_1.id

  weight = 50

}

resource "azurerm_traffic_manager_azure_endpoint" "two" {
  name                = "two"
  profile_id =          azurerm_traffic_manager_profile.clusters.id
  always_serve_enabled = true

  target_resource_id  = azurerm_public_ip.static_ip_2.id
  weight = 50
}

#
# GKE
#

# resource "google_container_cluster" "test-cluster-1" {
#   name     = "test-cluster-1"
#   location = var.region

#   initial_node_count = 1
#   node_locations = [ "${var.region}-a" ]
#   deletion_protection = false
#   node_config {
#     machine_type = "n1-standard-2"
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform",
#     ]
#   }
# }

# resource "null_resource" "kubeconfig" {
#   depends_on = [google_container_cluster.test-cluster-1]
#   provisioner "local-exec" {
#     command     = "gcloud container clusters get-credentials ${google_container_cluster.test-cluster-1.name} --region ${var.region} --project ${var.project_id}"
#   }
# }