# KUBE_AGENT_SUBNET_ID="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$VNET_GROUP/providers/Microsoft.Network/virtualNetworks/$KUBE_VNET_NAME/subnets/$KUBE_AGENT_SUBNET_NAME"
# az network route-table create -g $VNET_GROUP --name $DEPLOYMENT_NAME
resource "azurerm_route_table" "aks" {
  location            = data.azurerm_resource_group.net.location
  name                = "rt-${local.hub_instance_id}"
  resource_group_name = data.azurerm_resource_group.net.name
  tags                = data.azurerm_resource_group.net.tags

  lifecycle {
    # AKS will assume control of the tags
    ignore_changes = [tags]
  }
}

# az network route-table route create --resource-group $VNET_GROUP --name $DEPLOYMENT_NAME --route-table-name $DEPLOYMENT_NAME --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address $FW_PRIVATE_IP --subscription $SUBSCRIPTION_ID
resource "azurerm_route" "aks_traffic_to_hub" {
  address_prefix         = "0.0.0.0/0"
  name                   = "traffic_to_hub"
  next_hop_in_ip_address = module.firewall.private_ip_address
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = data.azurerm_resource_group.net.name
  route_table_name       = azurerm_route_table.aks.name
}

# az network vnet subnet update --route-table $DEPLOYMENT_NAME --ids $KUBE_AGENT_SUBNET_ID
resource "azurerm_subnet_route_table_association" "aks" {
  route_table_id = azurerm_route_table.aks.id
  subnet_id      = module.networks.subnets["agents"].id
}
