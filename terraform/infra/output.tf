output "cluster_one" {
  value     = azurerm_kubernetes_cluster.one.kube_config_raw
  sensitive = true
}

output "resource_group_name_one" {
  value = azurerm_resource_group.one.name
}


output "cluster_two" {
  value     = azurerm_kubernetes_cluster.two.kube_config_raw
  sensitive = true
}

output "resource_group_name_two" {
  value = azurerm_resource_group.two.name
}


# Output the IP Addresses
output "ip_address_1" {
  description = "IP address of the first static IP"
  value       = azurerm_public_ip.static_ip_1.ip_address
}

output "ip_address_2" {
  description = "IP address of the second static IP"
  value       = azurerm_public_ip.static_ip_2.ip_address
}