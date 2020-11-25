resource "azurerm_private_dns_zone" "private_link" {
  name                = "${local.project}.com"
  resource_group_name = azurerm_resource_group.net.name
}

