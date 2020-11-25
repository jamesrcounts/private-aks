resource "azurerm_resource_group" "main" {
  name     = "rg-${local.project}"
  location = local.location
  tags     = local.tags
}

resource "azurerm_resource_group" "net" {
  name     = "rg-${local.project}-networks"
  location = local.location
  tags     = local.tags
}

# az role assignment create --role "Contributor" --assignee $SERVICE_PRINCIPAL_ID -g $VNET_GROUP
resource "azurerm_role_assignment" "aks_vnet_contributor" {
  principal_id         = azuread_service_principal.aks_principal.object_id
  role_definition_name = "Contributor"
  scope                = azurerm_resource_group.net.id
}