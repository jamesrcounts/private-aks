# A block of IPs for the hub
resource "azurerm_public_ip_prefix" "hub" {
  location            = var.resource_group.location
  name                = "pib-hub-${local.instance_id}"
  prefix_length       = 31
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags
}