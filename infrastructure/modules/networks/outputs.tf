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