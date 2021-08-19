module "networks" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/networks?ref=lz"

  resource_group = data.azurerm_resource_group.net
}