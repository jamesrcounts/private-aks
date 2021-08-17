# move to governance
resource "azuread_group" "aks_administrators" {
  display_name = "aks-${local.env_instance_id}-administrators"
  description  = "Kubernetes administrators for the ${local.env_instance_id} cluster."
}

resource "azuread_group_member" "aks_administrator" {
  group_object_id  = azuread_group.aks_administrators.id
  member_object_id = data.azurerm_client_config.current.object_id
}