module "firewall" {
  source = "../"

  firewall_policy_id  = azurerm_firewall_policy.example.id
  public_ip_prefix_id = azurerm_public_ip_prefix.pib.id
  resource_group      = data.azurerm_resource_group.net
  route_table         = azurerm_route_table.aks_agents
  subnet_id           = azurerm_subnet.example.id

  log_analytics_workspace = merge(
    azurerm_log_analytics_workspace.example,
    {
      subscription_id = data.azurerm_subscription.current.subscription_id
    }
  )
}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "net" {
  name = "rg-${var.instance_id}"
}

resource "azurerm_firewall_policy" "example" {
  name                = "example"
  location            = data.azurerm_resource_group.net.location
  resource_group_name = data.azurerm_resource_group.net.name
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "acctest-01"
  location            = data.azurerm_resource_group.net.location
  resource_group_name = data.azurerm_resource_group.net.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.net.location
  resource_group_name = data.azurerm_resource_group.net.name
}

resource "azurerm_subnet" "example" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = data.azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip_prefix" "pib" {
  name                = "pib-${var.instance_id}"
  location            = data.azurerm_resource_group.net.location
  resource_group_name = data.azurerm_resource_group.net.name
  prefix_length       = 31
  tags                = data.azurerm_resource_group.net.tags
}

resource "azurerm_route_table" "aks_agents" {
  location            = data.azurerm_resource_group.net.location
  name                = "rt-agents-${var.instance_id}"
  resource_group_name = data.azurerm_resource_group.net.name
  tags                = data.azurerm_resource_group.net.tags

  lifecycle {
    # AKS will assume control of the tags
    ignore_changes = [tags]
  }
}

provider "azurerm" {
  features {}
}