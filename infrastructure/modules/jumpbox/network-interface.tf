# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-${local.instance_id}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags                = var.resource_group.tags

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.subnet.address_prefixes.0, 5)
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "pip-${local.instance_id}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Static"
  tags                = var.resource_group.tags
  public_ip_prefix_id = azurerm_public_ip_prefix.pib.id
  sku                 = "Standard"
}

resource "azurerm_public_ip_prefix" "pib" {
  name                = "pib-${local.instance_id}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  prefix_length       = 31
  tags                = var.resource_group.tags
}