module "policy" {
  source = "../"

  resource_group = data.azurerm_resource_group.net
}

output "id" {
  value = module.policy.firewall_policy_id
}

data "azurerm_resource_group" "net" {
  name = "rg-${var.instance_id}"
}

provider "azurerm" {
  features {}
}