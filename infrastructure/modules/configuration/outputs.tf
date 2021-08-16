output "instance_id" {
  value = {
    backend = data.azurerm_resource_group.backend.tags["instance_id"]
    hub     = nonsensitive(data.azurerm_key_vault_secret.values["hub-instance-id"].value)
    spoke   = nonsensitive(data.azurerm_key_vault_secret.values["spoke-instance-id"].value)
  }
}

output "log_analytics_workspace" {
  value = data.azurerm_log_analytics_workspace.main
}