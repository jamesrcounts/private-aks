# az network vnet create -g $VNET_GROUP -n $KUBE_VNET_NAME --address-prefixes 10.0.4.0/22
resource "azurerm_virtual_network" "spoke" {
  address_space       = ["10.0.4.0/22"]
  location            = azurerm_resource_group.net.location
  name                = local.vnet_name_spoke
  resource_group_name = azurerm_resource_group.net.name
  tags                = local.tags
}

# az network vnet subnet create -g $VNET_GROUP --vnet-name $KUBE_VNET_NAME -n $KUBE_ING_SUBNET_NAME --address-prefix 10.0.4.0/24
resource "azurerm_subnet" "ingress" {
  address_prefixes     = ["10.0.4.0/24"]
  name                 = local.subnet_name_ingress
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.spoke.name
}

# az network vnet subnet create -g $VNET_GROUP --vnet-name $KUBE_VNET_NAME -n $KUBE_AGENT_SUBNET_NAME --address-prefix 10.0.5.0/24
resource "azurerm_subnet" "agents" {
  address_prefixes                               = ["10.0.5.0/24"]
  enforce_private_link_endpoint_network_policies = true
  name                                           = local.subnet_name_agents
  resource_group_name                            = azurerm_resource_group.net.name
  virtual_network_name                           = azurerm_virtual_network.spoke.name
}

# az network vnet peering create -g $VNET_GROUP -n Spoke1ToHub --vnet-name $KUBE_VNET_NAME --remote-vnet $HUB_VNET_NAME --allow-vnet-access
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  allow_virtual_network_access = true
  name                         = "spoke-to-hub"
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  resource_group_name          = azurerm_resource_group.net.name
  virtual_network_name         = azurerm_virtual_network.spoke.name
}

# KUBE_AGENT_SUBNET_ID="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$VNET_GROUP/providers/Microsoft.Network/virtualNetworks/$KUBE_VNET_NAME/subnets/$KUBE_AGENT_SUBNET_NAME"
# az network route-table create -g $VNET_GROUP --name $DEPLOYMENT_NAME
resource "azurerm_route_table" "aks" {
  location            = azurerm_resource_group.net.location
  name                = "rt-${local.project}"
  resource_group_name = azurerm_resource_group.net.name
  tags                = local.tags
}

# az network route-table route create --resource-group $VNET_GROUP --name $DEPLOYMENT_NAME --route-table-name $DEPLOYMENT_NAME --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address $FW_PRIVATE_IP --subscription $SUBSCRIPTION_ID
resource "azurerm_route" "aks_traffic_to_hub" {
  address_prefix         = "0.0.0.0/0"
  name                   = "traffic_to_hub"
  next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration.0.private_ip_address
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = azurerm_resource_group.net.name
  route_table_name       = azurerm_route_table.aks.name
}

# az network vnet subnet update --route-table $DEPLOYMENT_NAME --ids $KUBE_AGENT_SUBNET_ID
resource "azurerm_subnet_route_table_association" "aks" {
  subnet_id      = azurerm_subnet.agents.id
  route_table_id = azurerm_route_table.aks.id
}
