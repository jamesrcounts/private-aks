# Imported from: https://raw.githubusercontent.com/Azure/azure-docs-json-samples/master/azure-firewall/AzureFirewall.omsview
resource "azurerm_dashboard" "dashboard" {
  location            = var.resource_group.location
  name                = "AzureFirewall"
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags

  dashboard_properties = templatefile(
    "${path.module}/dashboards/AzureFirewall.omsview.hcl",
    {
      location              = var.log_analytics_workspace.location
      resource_group_name   = var.log_analytics_workspace.resource_group_name
      subscription_id       = var.log_analytics_workspace.subscription_id,
      workspace_id          = var.log_analytics_workspace.workspace_id
      workspace_api_version = "2020-08-01"
  })
}