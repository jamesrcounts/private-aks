# A block of IPs for the hub
resource "azurerm_public_ip_prefix" "hub" {
  location            = data.azurerm_resource_group.net.location
  name                = "pib-${local.project}-hub"
  prefix_length       = 31
  resource_group_name = data.azurerm_resource_group.net.name
  tags                = local.tags
}
