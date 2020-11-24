locals {
  aks_cluster_name     = "${local.project}-cluster"
  location             = "centralus"
  project              = "private-aks"
  subnet_name_agents   = "aks-agents-subnet"
  subnet_name_firewall = "AzureFirewallSubnet"
  subnet_name_ingress  = "ingress-subnet"
  subnet_name_jump     = "jumpbox-subnet"
  vnet_name_hub        = "hub-vnet"
  vnet_name_spoke      = "aks-vnet"

  tags = {
    environment = local.project
  }
}

data "azurerm_client_config" "current" {}
resource "random_pet" "fido" {}
