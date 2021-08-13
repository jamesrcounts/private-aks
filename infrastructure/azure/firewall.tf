module "firewall" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/firewall?ref=lz"

  firewall_policy_id = module.firewall_policy.firewall_policy_id
  resource_group     = data.azurerm_resource_group.net
  subnet_id          = module.networks.subnets["firewall"].id
  log_analytics_workspace = merge(
    azurerm_log_analytics_workspace.insights,
    {
      subscription_id = data.azurerm_client_config.current.subscription_id
    }
  )
}

module "firewall_policy" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/firewall-policy-aks?ref=lz"

  resource_group = data.azurerm_resource_group.net
}