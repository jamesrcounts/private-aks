locals {
  backend_instance_id = data.azurerm_resource_group.net.tags["backend_instance_id"]
  hub_instance_id     = data.azurerm_resource_group.net.tags["instance_id"]
  env_instance_id     = data.azurerm_resource_group.main.tags["instance_id"]
}

data "azurerm_client_config" "current" {}