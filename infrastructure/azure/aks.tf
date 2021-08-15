module "aks_cluster" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/aks-private-cluster?ref=lz"

  depends_on = [
    azurerm_subnet_route_table_association.aks,
    azurerm_route.aks_traffic_to_hub
  ]

  admin_group_object_id      = azuread_group.aks_administrators.object_id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.main.id
  resource_group             = data.azurerm_resource_group.main
  subnet_id                  = module.networks.subnets["agents"].id
  user_assigned_identity_id  = module.aks_cluster_identity.msi_resource_id
  private_dns_zone_id        = azurerm_private_dns_zone.azmk8s.id
}