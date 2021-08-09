# az network vnet peering create -g $VNET_GROUP -n HubToSpoke1 --vnet-name $HUB_VNET_NAME --remote-vnet $KUBE_VNET_NAME --allow-vnet-access
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  allow_virtual_network_access = true
  name                         = "hub-to-spoke"
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  resource_group_name          = var.resource_group.name
  virtual_network_name         = azurerm_virtual_network.hub.name
}
