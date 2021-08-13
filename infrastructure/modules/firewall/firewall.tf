# az network firewall create --name $DEPLOYMENT_NAME --resource-group $VNET_GROUP --location $LOCATION
# az network firewall ip-config create --firewall-name $DEPLOYMENT_NAME --name $DEPLOYMENT_NAME --public-ip-address $DEPLOYMENT_NAME --resource-group $VNET_GROUP --vnet-name $HUB_VNET_NAME
resource "azurerm_firewall" "fw" {
  firewall_policy_id  = var.firewall_policy_id
  location            = var.resource_group.location
  name                = "fw-${local.instance_id}"
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags

  ip_configuration {
    name                 = "pip0"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}
