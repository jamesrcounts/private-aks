output "firewall_id" {
  description = "The resource ID for the Azure Firewall instance created by this module."
  value       = azurerm_firewall.fw.id
}