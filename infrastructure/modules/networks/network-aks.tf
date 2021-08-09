# az network vnet create -g $VNET_GROUP -n $KUBE_VNET_NAME --address-prefixes 10.0.4.0/22
resource "azurerm_virtual_network" "spoke" {
  address_space       = ["10.0.4.0/22"]
  location            = var.resource_group.location
  name                = "vnet-aks-${local.instance_id}"
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags
}

# az network vnet subnet create -g $VNET_GROUP --vnet-name $KUBE_VNET_NAME -n $KUBE_ING_SUBNET_NAME --address-prefix 10.0.4.0/24
resource "azurerm_subnet" "ingress" {
  address_prefixes     = ["10.0.4.0/24"]
  name                 = "ingress-subnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.spoke.name
}

# az network vnet subnet create -g $VNET_GROUP --vnet-name $KUBE_VNET_NAME -n $KUBE_AGENT_SUBNET_NAME --address-prefix 10.0.5.0/24
resource "azurerm_subnet" "agents" {
  address_prefixes                               = ["10.0.5.0/24"]
  enforce_private_link_endpoint_network_policies = true
  name                                           = "aks-agents-subnet"
  resource_group_name                            = var.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.spoke.name
}

# az network vnet peering create -g $VNET_GROUP -n Spoke1ToHub --vnet-name $KUBE_VNET_NAME --remote-vnet $HUB_VNET_NAME --allow-vnet-access
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  allow_virtual_network_access = true
  name                         = "spoke-to-hub"
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  resource_group_name          = var.resource_group.name
  virtual_network_name         = azurerm_virtual_network.spoke.name
}
