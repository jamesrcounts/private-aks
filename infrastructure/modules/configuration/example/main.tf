module "configuration" {
  source = "../"

  backend_resource_group_name = var.backend_resource_group_name
}

output "ids" {
  value = module.configuration.instance_id
}

provider "azurerm" {
  features {}
}