locals {
  firewall_diagnostics = sort([
    "AzureFirewallApplicationRule",
    "AzureFirewallDnsProxy",
    "AzureFirewallNetworkRule",
  ])
}

resource "azurerm_monitor_diagnostic_setting" "firewall" {
  log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  name                       = "firewall"
  storage_account_id         = azurerm_storage_account.diagnostics.id
  target_resource_id         = azurerm_firewall.fw.id

  dynamic "log" {
    for_each = local.firewall_diagnostics
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = 17
      }
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}