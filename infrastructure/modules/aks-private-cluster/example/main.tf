module "test" {
  source = "../"

  resource_group             = data.azurerm_resource_group.net
  admin_group_object_id      = azuread_group.aks_administrators.object_id
  user_assigned_identity_id  = azurerm_user_assigned_identity.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  subnet_id                  = azurerm_subnet.example.id
  private_dns_zone_id        = azurerm_private_dns_zone.example.id
}

data "azurerm_resource_group" "net" {
  name = "rg-${var.instance_id}"
}

resource "azuread_group" "aks_administrators" {
  display_name = "${var.instance_id}-administrators"
  description  = "Kubernetes administrators for the ${var.instance_id} cluster."
}

resource "azurerm_user_assigned_identity" "aks" {
  location            = data.azurerm_resource_group.net.location
  name                = "uai-aks-${var.instance_id}"
  resource_group_name = data.azurerm_resource_group.net.name
  tags                = data.azurerm_resource_group.net.tags
}

resource "azurerm_log_analytics_workspace" "insights" {
  name                = "la-${var.instance_id}"
  location            = data.azurerm_resource_group.net.location
  resource_group_name = data.azurerm_resource_group.net.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = data.azurerm_resource_group.net.tags
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.net.location
  resource_group_name = data.azurerm_resource_group.net.name
}

resource "azurerm_subnet" "example" {
  name                 = "example"
  resource_group_name  = data.azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.eastus2.azmk8s.io"
  resource_group_name = data.azurerm_resource_group.net.name
}

provider "azurerm" {
  features {}
}