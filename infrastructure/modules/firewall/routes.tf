# az network route-table route create --resource-group $VNET_GROUP --name $DEPLOYMENT_NAME --route-table-name $DEPLOYMENT_NAME --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address $FW_PRIVATE_IP --subscription $SUBSCRIPTION_ID
resource "azurerm_route" "traffic_to_hub" {
  address_prefix         = "0.0.0.0/0"
  name                   = "traffic_to_hub"
  next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration.0.private_ip_address
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = var.route_table.resource_group_name
  route_table_name       = var.route_table.name
}


