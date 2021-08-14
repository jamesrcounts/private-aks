data "azurerm_kubernetes_service_versions" "current" {
  location = var.resource_group.location
}