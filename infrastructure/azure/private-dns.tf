resource "azurerm_private_dns_zone" "azmk8s" {
  name                = "privatelink.eastus2.azmk8s.io"
  resource_group_name = data.azurerm_resource_group.net.name
  tags                = data.azurerm_resource_group.net.tags
}