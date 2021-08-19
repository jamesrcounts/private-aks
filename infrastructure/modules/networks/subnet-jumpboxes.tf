# az network vnet subnet create -g $VNET_GROUP --vnet-name $HUB_VNET_NAME -n $HUB_JUMP_SUBNET_NAME --address-prefix 10.0.1.0/24
resource "azurerm_subnet" "jumpboxes" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "jumpbox-subnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.hub.name
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${local.instance_id}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags
}

resource "azurerm_network_security_rule" "allow_ssh_in" {
  name                        = "SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

// resource "azurerm_network_security_rule" "default_deny_in" {
//   name                        = "deny-inbound"
//   priority                    = 4096
//   direction                   = "Inbound"
//   access                      = "Deny"
//   protocol                    = "*"
//   source_port_range           = "*"
//   destination_port_range      = "*"
//   source_address_prefix       = "*"
//   destination_address_prefix  = "*"
//   resource_group_name         = var.resource_group.name
//   network_security_group_name = azurerm_network_security_group.nsg.name
// }

// resource "azurerm_network_security_rule" "default_deny_out" {
//   name                        = "deny-outbound"
//   priority                    = 4096
//   direction                   = "Outbound"
//   access                      = "Deny"
//   protocol                    = "*"
//   source_port_range           = "*"
//   destination_port_range      = "*"
//   source_address_prefix       = "*"
//   destination_address_prefix  = "*"
//   resource_group_name         = var.resource_group.name
//   network_security_group_name = azurerm_network_security_group.nsg.name
// }

resource "azurerm_subnet_network_security_group_association" "nsg_to_subnet" {
  subnet_id                 = azurerm_subnet.jumpboxes.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}