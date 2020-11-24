resource "azuread_group" "aks_administrators" {
  name        = "${local.aks_cluster_name}-administrators"
  description = "Kubernetes administrators for the ${local.aks_cluster_name} cluster."
}

resource "azuread_group_member" "aks_administrator" {
  group_object_id  = azuread_group.aks_administrators.id
  member_object_id = data.azurerm_client_config.current.object_id
}