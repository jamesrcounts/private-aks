data "azurerm_log_analytics_workspace" "main" {
  name                = "la-${local.backend_instance_id}"
  resource_group_name = "rg-backend-${local.backend_instance_id}"
}