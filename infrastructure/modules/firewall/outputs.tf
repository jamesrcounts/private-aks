output "firewall_id" {
  description = "The resource ID for the Azure Firewall instance created by this module."
  value       = azurerm_firewall.fw.id
}

output "private_ip_address" {
  description = "The private IP address for this firewall."
  value       = azurerm_firewall.fw.ip_configuration.0.private_ip_address
}