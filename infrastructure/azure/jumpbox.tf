module "jumpbox" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/jumpbox?ref=lz"

  public_ip_prefix_id = module.networks.public_ip_prefix_id
  resource_group      = data.azurerm_resource_group.net
  subnet              = module.networks.subnets["jumpbox"]
}