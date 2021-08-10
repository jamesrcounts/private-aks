# A block of IPs for the hub
resource "azurerm_public_ip_prefix" "hub" {
  location            = var.resource_group.location
  name                = "pib-hub-${local.instance_id}"
  prefix_length       = 31
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags
}

# az network public-ip create -g $VNET_GROUP -n $DEPLOYMENT_NAME --sku Standard
resource "azurerm_public_ip" "firewall" {
  allocation_method   = "Static"
  sku                 = "Standard"
  location            = var.resource_group.location
  name                = "pip-fw-${local.instance_id}"
  public_ip_prefix_id = azurerm_public_ip_prefix.hub.id
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags
}