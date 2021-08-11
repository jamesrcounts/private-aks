module "firewall" {
  source = "../"

  resource_group = data.azurerm_resource_group.net
  subnet_id      = azurerm_subnet.example.id
  log_analytics_workspace = merge(
    azurerm_log_analytics_workspace.example,
    {
      subscription_id = data.azurerm_subscription.current.id
    }
  )
}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "net" {
  name = "rg-${var.instance_id}"
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

provider "azurerm" {
  features {}
}