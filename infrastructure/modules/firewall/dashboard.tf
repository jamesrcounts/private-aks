# Imported from: https://raw.githubusercontent.com/Azure/azure-docs-json-samples/master/azure-firewall/AzureFirewall.omsview
resource "azurerm_dashboard" "dashboard" {
  location            = var.resource_group.location
  name                = "AzureFirewall"
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags
  dashboard_properties = templatefile(
    "${path.module}/dashboards/AzureFirewall.omsview.hcl",
    {
      location              = var.resource_group.location
      resource_group_name   = var.resource_group.name
      subscription_id       = "",
      workspace_id          = var.log_analytics_workspace_id
      workspace_api_version = ""
  })
}