output "imports" {
  value = { for k, v in data.azurerm_key_vault_secret.values : k => v.value }
}

output "instance_id" {
  value = {
    backend    = data.azurerm_resource_group.backend.tags["instance_id"]
    networking = nonsensitive(data.azurerm_key_vault_secret.values["networking-instance-id"].value)
    appenv     = nonsensitive(data.azurerm_key_vault_secret.values["appenv-instance-id"].value)
  }
}

output "key_vault_id" {
  value = data.azurerm_key_vault.config.id
}

output "log_analytics_workspace" {
  value = data.azurerm_log_analytics_workspace.main
}