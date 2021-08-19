# az network vnet create -g $VNET_GROUP -n $HUB_VNET_NAME --address-prefixes 10.0.0.0/22
resource "azurerm_virtual_network" "hub" {
  address_space       = ["10.0.0.0/22"]
  location            = var.resource_group.location
  name                = "vnet-hub-${local.instance_id}"
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags
}

# az network vnet subnet create -g $VNET_GROUP --vnet-name $HUB_VNET_NAME -n $HUB_FW_SUBNET_NAME --address-prefix 10.0.0.0/24
resource "azurerm_subnet" "firewall" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.hub.name
}


