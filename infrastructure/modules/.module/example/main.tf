module "test" {
  source= "../"
}

data "azurerm_resource_group" "net" {
  name = "rg-${var.instance_id}"
}

provider "azurerm" {
  features {}
}