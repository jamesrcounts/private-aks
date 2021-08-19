data "azurerm_resource_group" "main" {
  name = "rg-${local.env_instance_id}"
}

data "azurerm_resource_group" "net" {
  name = "rg-${module.configuration.instance_id["networking"]}"
}