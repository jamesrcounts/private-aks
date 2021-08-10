# Imported from: https://raw.githubusercontent.com/Azure/azure-docs-json-samples/master/azure-firewall/AzureFirewall.omsview
resource "azurerm_dashboard" "dashboard" {
  dashboard_properties = file("${path.module}/dashboards/AzureFirewall.omsview")
  location             = var.resource_group.location
  name                 = "AzureFirewall"
  resource_group_name  = var.resource_group.name
  tags                 = var.resource_group.tags
}