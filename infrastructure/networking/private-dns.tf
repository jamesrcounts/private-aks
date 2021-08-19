resource "azurerm_private_dns_zone" "azmk8s" {
  name                = "privatelink.${data.azurerm_resource_group.net.location}.azmk8s.io"
  resource_group_name = data.azurerm_resource_group.net.name
  tags                = data.azurerm_resource_group.net.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_link_to_hub" {
  name                  = "hub"
  resource_group_name   = data.azurerm_resource_group.net.name
  private_dns_zone_name = azurerm_private_dns_zone.azmk8s.name
  virtual_network_id    = module.networks.networks["hub"].id
  tags                  = data.azurerm_resource_group.net.tags
}







