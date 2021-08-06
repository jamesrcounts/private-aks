data "azurerm_key_vault_secret" "values" {
  for_each = toset(["hub-instance-id", "spoke-instance-id"])

  name         = each.key
  key_vault_id = data.azurerm_key_vault.config.id
}