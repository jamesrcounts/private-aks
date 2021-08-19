locals {
  env_instance_id = module.configuration.instance_id["appenv"]
  subnets         = jsondecode(module.configuration.imports["subnets"])
}

data "azurerm_client_config" "current" {}