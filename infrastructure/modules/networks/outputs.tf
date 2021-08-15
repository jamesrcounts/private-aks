output "public_ip_prefix_id" {
  description = "Public IP address prefix resource ID."
  value       = azurerm_public_ip_prefix.hub.id
}

output "subnets" {
  description = "Describes the subnets created by this module."
  value = {
    agents = {
      id = azurerm_subnet.agents.id
    }
    jumpbox = {
      id               = azurerm_subnet.jumpboxes.id
      address_prefixes = azurerm_subnet.jumpboxes.address_prefixes
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