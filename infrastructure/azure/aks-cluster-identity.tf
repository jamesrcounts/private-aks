module "aks_cluster_identity" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/aks-cluster-mi?ref=lz"

  resource_group = data.azurerm_resource_group.main
  scope          = data.azurerm_resource_group.net.id
}