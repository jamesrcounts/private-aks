resource "azurerm_kubernetes_cluster_node_pool" "user" {
  availability_zones    = [1, 2, 3]
  enable_auto_scaling   = true
  enable_node_public_ip = false
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  max_count             = 3
  max_pods              = 100
  min_count             = 1
  mode                  = "User"
  name                  = "user"
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb       = 1024
  os_type               = "Linux"
  priority              = "Regular"
  tags                  = var.resource_group.tags
  vm_size               = "Standard_DS2_v2"
  vnet_subnet_id        = var.subnet_id
}