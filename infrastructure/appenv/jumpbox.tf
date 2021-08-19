module "jumpbox" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/jumpbox?ref=2021.08"

  public_ip_prefix_id = module.configuration.imports["public-ip-prefix-id"]
  resource_group      = data.azurerm_resource_group.net
  subnet              = local.subnets["jumpbox"]
}
