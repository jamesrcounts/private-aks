# Imported from: https://github.com/Azure/Azure-Network-Security/blob/59f3913c192c74718fb1cab675f32c3b375da8a4/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook/Azure%20Firewall_ARM.json
# License: https://github.com/Azure/Azure-Network-Security/blob/59f3913c192c74718fb1cab675f32c3b375da8a4/LICENSE
resource "azurerm_template_deployment" "workbook" {
  name                = "AzureFirewall"
  resource_group_name = var.resource_group.name
  deployment_mode     = "Incremental"

  template_body = templatefile(
    "${path.module}/workbooks/AzureFirewall.arm.json.hcl",
    {
      workspace_resource_group_name = var.log_analytics_workspace.resource_group_name
      workspace_subscription_id     = var.log_analytics_workspace.subscription_id,
      workspace_name                = var.log_analytics_workspace.name
  })
}