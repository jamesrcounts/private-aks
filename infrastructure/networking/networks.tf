module "networks" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/networks?ref=2021.08"

  resource_group = data.azurerm_resource_group.net
}