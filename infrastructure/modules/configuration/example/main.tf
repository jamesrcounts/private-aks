module "configuration" {
  source = "../"

  backend_resource_group_name = var.backend_resource_group_name
  additional_imports          = ["subnets"]
}

data "azurerm_key_vault" "config" {
  name                = "kv-${var.instance_id}"
  resource_group_name = var.backend_resource_group_name
}

resource "azurerm_key_vault_secret" "exports" {
  for_each = {
    subnets = jsonencode({
      a = "b"
    })
  }

  key_vault_id = data.azurerm_key_vault.config.id
  name         = each.key
  value        = each.value
}

output "ids" {
  value = module.configuration.instance_id
}

output "subnets" {
  value = nonsensitive(module.configuration.imports["subnets"])
}

provider "azurerm" {
  features {}
}