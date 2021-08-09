locals {
  aks_cluster_name        = "${local.project}-cluster"
  aks_node_resource_group = "${data.azurerm_resource_group.main.name}-aks"
  firewall_name           = "fw-${local.project}"
  location                = "centralus"
  project                 = "private-aks"
  #subnet_name_agents      = "aks-agents-subnet"
  subnet_id_agents = module.networks.subnets["agents"].id
  #subnet_name_firewall    = "AzureFirewallSubnet"
  #subnet_name_ingress     = "ingress-subnet"
  #subnet_name_jump        = "jumpbox-subnet"
  #vnet_name_hub           = "hub-vnet"
  #vnet_name_spoke         = "aks-vnet"

  tags = {
    environment = local.project
  }
}

data "azurerm_client_config" "current" {}
resource "random_pet" "fido" {}
