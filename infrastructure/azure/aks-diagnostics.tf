locals {
  aks_diagnostics = sort([
    "kube-apiserver",
    "kube-audit",
    "kube-audit-admin",
    "kube-controller-manager",
    "kube-scheduler",
    "cluster-autoscaler",
    "guard",
  ])
}

resource "azurerm_monitor_diagnostic_setting" "aks_log_storage" {
  log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  name                       = "aks-log-storage"
  storage_account_id         = azurerm_storage_account.diagnostics.id
  target_resource_id         = azurerm_kubernetes_cluster.aks.id

  dynamic "log" {
    for_each = local.aks_diagnostics
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