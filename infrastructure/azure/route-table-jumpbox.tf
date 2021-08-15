// resource "azurerm_route_table" "jumpbox" {
//   location            = data.azurerm_resource_group.net.location
//   name                = "rt-jumpbox-${local.hub_instance_id}"
//   resource_group_name = data.azurerm_resource_group.net.name
//   tags                = data.azurerm_resource_group.net.tags
// }

// resource "azurerm_route" "jumpbox_traffic_to_hub" {
//   address_prefix         = "0.0.0.0/0"
//   name                   = "traffic_to_hub"
//   next_hop_in_ip_address = module.firewall.private_ip_address
//   next_hop_type          = "VirtualAppliance"
//   resource_group_name    = data.azurerm_resource_group.net.name
//   route_table_name       = azurerm_route_table.jumpbox.name
// }

// resource "azurerm_subnet_route_table_association" "jumpbox" {
//   route_table_id = azurerm_route_table.jumpbox.id
//   subnet_id      = module.networks.subnets["jumpbox"].id
// }
