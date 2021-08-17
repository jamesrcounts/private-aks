resource "azurerm_key_vault_secret" "exports" {
  for_each = {
    public-ip-prefix-id = module.networks.public_ip_prefix_id
    subnets             = jsonencode(module.networks.subnets)
  }

  key_vault_id = module.configuration.key_vault_id
  name         = each.key
  value        = each.value
}