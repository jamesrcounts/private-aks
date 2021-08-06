# az network vnet create -g $VNET_GROUP -n $HUB_VNET_NAME --address-prefixes 10.0.0.0/22
resource "azurerm_virtual_network" "hub" {
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.net.location
  name                = local.vnet_name_hub
  resource_group_name = azurerm_resource_group.net.name
  tags                = local.tags
}

# az network vnet subnet create -g $VNET_GROUP --vnet-name $HUB_VNET_NAME -n $HUB_FW_SUBNET_NAME --address-prefix 10.0.0.0/24
resource "azurerm_subnet" "firewall" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = local.subnet_name_firewall
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.hub.name
}

# az network vnet subnet create -g $VNET_GROUP --vnet-name $HUB_VNET_NAME -n $HUB_JUMP_SUBNET_NAME --address-prefix 10.0.1.0/24
resource "azurerm_subnet" "jumpboxes" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = local.subnet_name_jump
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.hub.name
}

# az network vnet peering create -g $VNET_GROUP -n HubToSpoke1 --vnet-name $HUB_VNET_NAME --remote-vnet $KUBE_VNET_NAME --allow-vnet-access
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  allow_virtual_network_access = true
  name                         = "hub-to-spoke"
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  resource_group_name          = azurerm_resource_group.net.name
  virtual_network_name         = azurerm_virtual_network.hub.name
}

# A block of IPs for the hub
resource "azurerm_public_ip_prefix" "hub" {
  location            = azurerm_resource_group.net.location
  name                = "pib-${local.project}-hub"
  prefix_length       = 31
  resource_group_name = azurerm_resource_group.net.name
  tags                = local.tags
}

# resource "azurerm_private_dns_zone_virtual_network_link" "private_link_to_hub" {
#   name                  = "hub"
#   resource_group_name   = azurerm_kubernetes_cluster.aks.node_resource_group
#   private_dns_zone_name = azprivatedns_zones.current.dns_zones.0.name
#   virtual_network_id    = azurerm_virtual_network.hub.id
# }