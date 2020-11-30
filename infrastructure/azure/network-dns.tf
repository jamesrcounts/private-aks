resource "azurerm_private_dns_zone" "private_link" {
  name                = "${local.project}.com"
  resource_group_name = azurerm_resource_group.net.name
}

resource "az_dns_zones" "current" {
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
}