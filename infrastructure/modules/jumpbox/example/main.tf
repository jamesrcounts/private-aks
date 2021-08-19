module "test" {
  source = "../"

  public_ip_prefix_id = azurerm_public_ip_prefix.pib.id
  resource_group      = data.azurerm_resource_group.net
  subnet              = azurerm_subnet.example
}

data "azurerm_resource_group" "net" {
  name = "rg-${var.instance_id}"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.net.location
  resource_group_name = data.azurerm_resource_group.net.name
}

resource "azurerm_subnet" "example" {
  name                 = "jumpbox"
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

provider "azurerm" {
  features {}
}