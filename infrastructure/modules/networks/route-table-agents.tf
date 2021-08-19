# KUBE_AGENT_SUBNET_ID="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$VNET_GROUP/providers/Microsoft.Network/virtualNetworks/$KUBE_VNET_NAME/subnets/$KUBE_AGENT_SUBNET_NAME"
# az network route-table create -g $VNET_GROUP --name $DEPLOYMENT_NAME
resource "azurerm_route_table" "aks_agents" {
  location            = var.resource_group.location
  name                = "rt-agents-${local.instance_id}"
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags

  lifecycle {
    # AKS will assume control of the tags
    ignore_changes = [tags]
  }
}

# az network vnet subnet update --route-table $DEPLOYMENT_NAME --ids $KUBE_AGENT_SUBNET_ID
resource "azurerm_subnet_route_table_association" "aks_agents" {
  route_table_id = azurerm_route_table.aks_agents.id
  subnet_id      = azurerm_subnet.agents.id
}