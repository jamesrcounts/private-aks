# az network public-ip create -g $VNET_GROUP -n $DEPLOYMENT_NAME --sku Standard
resource "azurerm_public_ip" "firewall" {
  allocation_method   = "Static"
  sku                 = "Standard"
  location            = azurerm_resource_group.net.location
  name                = local.project
  public_ip_prefix_id = azurerm_public_ip_prefix.hub.id
  resource_group_name = azurerm_resource_group.net.name
  tags                = local.tags
}

# az network firewall create --name $DEPLOYMENT_NAME --resource-group $VNET_GROUP --location $LOCATION
# az network firewall ip-config create --firewall-name $DEPLOYMENT_NAME --name $DEPLOYMENT_NAME --public-ip-address $DEPLOYMENT_NAME --resource-group $VNET_GROUP --vnet-name $HUB_VNET_NAME
resource "azurerm_firewall" "fw" {
  name                = local.firewall_name
  location            = azurerm_resource_group.net.location
  resource_group_name = azurerm_resource_group.net.name

  ip_configuration {
    name                 = "${local.firewall_name}-ip-config"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

# FW_PRIVATE_IP=$(az network firewall show -g $VNET_GROUP -n $DEPLOYMENT_NAME --query "ipConfigurations[0].privateIpAddress" -o tsv)
# az monitor log-analytics workspace create --resource-group $VNET_GROUP --workspace-name $DEPLOYMENT_NAME --location $LOCATION