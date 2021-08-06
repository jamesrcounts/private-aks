output "instance_id" {
  value = {
    backend = data.azurerm_resource_group.backend.tags["instance_id"]
    hub     = data.azurerm_key_vault_secret.values["hub-instance-id"].value
    spoke   = data.azurerm_key_vault_secret.values["spoke-instance-id"].value
  }
}