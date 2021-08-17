locals {
  env_instance_id = module.configuration.instance_id["spoke"]
  subnets         = jsondecode(module.configuration.imports["subnets"])
}

data "azurerm_client_config" "current" {}