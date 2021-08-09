module "networks" {
  source = "../modules/networks"

  resource_group = data.azurerm_resource_group.net
}