module "diagnostics" {
  source = "github.com/jamesrcounts/devops-governance.git//modules/diagnostics?ref=diagnostics-0.0.1"

  log_analytics_workspace_id = var.log_analytics_workspace.id

  monitored_services = {
    fw = azurerm_firewall.fw.id
  }
}
