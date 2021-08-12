module "firewall" {
  source = "../modules/firewall"

  resource_group = data.azurerm_resource_group.net
  subnet_id      = module.networks.subnets["firewall"].id
  log_analytics_workspace = merge(
    azurerm_log_analytics_workspace.insights,
    {
      subscription_id = data.azurerm_client_config.current.subscription_id
    }
  )
}