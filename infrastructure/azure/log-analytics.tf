resource "azurerm_log_analytics_workspace" "insights" {
  name                = "la-${local.project}-${random_pet.fido.id}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

