data "azurerm_kubernetes_service_versions" "current" {
  include_preview = false
  location        = var.resource_group.location
}