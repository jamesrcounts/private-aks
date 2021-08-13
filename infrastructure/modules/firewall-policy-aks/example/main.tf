module "policy" {
  source = "../"

  resource_group = data.azurerm_resource_group.net
}

data "azurerm_resource_group" "net" {
  name = "rg-${var.instance_id}"
}

provider "azurerm" {
  features {}
}