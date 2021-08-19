module "firewall" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/firewall?ref=2021.08"

  firewall_policy_id  = module.firewall_policy.firewall_policy_id
  public_ip_prefix_id = module.networks.public_ip_prefix_id
  resource_group      = data.azurerm_resource_group.net
  route_table         = module.networks.route_table
  subnet_id           = module.networks.subnets["firewall"].id

  log_analytics_workspace = merge(
    module.configuration.log_analytics_workspace,
    {
      subscription_id = data.azurerm_client_config.current.subscription_id
    }
  )
}

module "firewall_policy" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/firewall-policy-aks?ref=2021.08"

  resource_group = data.azurerm_resource_group.net
}