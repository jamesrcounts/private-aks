data "azurerm_resource_group" "main" {
  name = "rg-${module.configuration.instance_id["spoke"]}"
}

data "azurerm_resource_group" "net" {
  name = "rg-${module.configuration.instance_id["hub"]}"
}

# az role assignment create --role "Contributor" --assignee $SERVICE_PRINCIPAL_ID -g $VNET_GROUP
resource "azurerm_role_assignment" "aks_vnet_contributor" {
  principal_id         = azuread_service_principal.aks_principal.object_id
  role_definition_name = "Contributor"
  scope                = data.azurerm_resource_group.net.id
}