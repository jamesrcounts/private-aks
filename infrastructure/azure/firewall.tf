module "firewall" {
  source = "../modules/firewall"

  log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  resource_group             = data.azurerm_resource_group.net
  subnet_id                  = module.networks.subnets["firewall"].id
}