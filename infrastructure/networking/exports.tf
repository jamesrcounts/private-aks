resource "azurerm_key_vault_secret" "exports" {
  for_each = {
    private-dns-zone-id = azurerm_private_dns_zone.azmk8s.id
    public-ip-prefix-id = module.networks.public_ip_prefix_id
    subnets             = jsonencode(module.networks.subnets)
  }

  key_vault_id = module.configuration.key_vault_id
  name         = each.key
  value        = each.value
}