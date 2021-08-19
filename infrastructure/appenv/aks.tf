module "aks_cluster" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/aks-private-cluster?ref=2021.08"

  admin_group_object_id      = module.configuration.imports["admin-group-object-id"]
  log_analytics_workspace_id = module.configuration.log_analytics_workspace.id
  resource_group             = data.azurerm_resource_group.main
  subnet_id                  = local.subnets["agents"].id
  user_assigned_identity_id  = module.configuration.imports["msi-resource-id"]
  private_dns_zone_id        = module.configuration.imports["private-dns-zone-id"]
}