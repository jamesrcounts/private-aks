// az identity create --name $KUBE_NAME --resource-group $KUBE_GROUP
resource "azurerm_user_assigned_identity" "aks" {
  location            = var.resource_group.location
  name                = "uai-aks-${local.instance_id}"
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags
}


// MSI_RESOURCE_ID=$(az identity show -n $KUBE_NAME -g $KUBE_GROUP -o json | jq -r ".id")
// MSI_CLIENT_ID=$(az identity show -n $KUBE_NAME -g $KUBE_GROUP -o json | jq -r ".clientId")
// az role assignment create --role "Virtual Machine Contributor" --assignee $MSI_CLIENT_ID -g $VNET_GROUP
resource "azurerm_role_assignment" "aks_vnet_contributor" {
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  role_definition_name = "Network Contributor"
  scope                = var.scope
}

resource "azurerm_role_assignment" "aks_dns_zone_contributor" {
  scope                = var.scope
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}