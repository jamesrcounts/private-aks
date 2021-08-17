data "azurerm_key_vault_secret" "values" {
  for_each = toset(
    distinct(
      concat(
        ["hub-instance-id", "spoke-instance-id"],
        var.additional_imports
      )
    )
  )

  name         = each.key
  key_vault_id = data.azurerm_key_vault.config.id
}