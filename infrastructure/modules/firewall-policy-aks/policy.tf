resource "azurerm_firewall_policy" "policy" {
  name                = "afwp-${local.instance_id}"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.resource_group.tags
}