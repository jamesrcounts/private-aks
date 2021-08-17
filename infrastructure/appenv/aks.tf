module "aks_cluster" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/aks-private-cluster?ref=lz"

  depends_on = [module.aks_cluster_identity]

  admin_group_object_id      = azuread_group.aks_administrators.object_id
  log_analytics_workspace_id = module.configuration.log_analytics_workspace.id
  resource_group             = data.azurerm_resource_group.main
  subnet_id                  = local.subnets["agents"].id
  user_assigned_identity_id  = module.aks_cluster_identity.msi_resource_id
  private_dns_zone_id        = module.configuration.imports["private-dns-zone-id"]
}