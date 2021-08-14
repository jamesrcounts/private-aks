output "subnets" {
  description = "Describes the subnets created by this module"
  value = {
    agents = {
      id = azurerm_subnet.agents.id
    }
    firewall = {
      id = azurerm_subnet.firewall.id
    }
  }
}

output "networks" {
  description = "Describes the networks created by this module."
  value = {
    hub = {
      id = azurerm_virtual_network.hub.id
    }
  }
}