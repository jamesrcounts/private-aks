data "azurerm_resource_group" "net" {
  name = "rg-${module.configuration.instance_id["hub"]}"
}

