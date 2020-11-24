resource "azurerm_resource_group" "main" {
  name     = "rg-${local.project}"
  location = local.location
  tags     = local.tags
}

resource "azurerm_resource_group" "net" {
  name     = "rg-${local.project}-networks"
  location = local.location
  tags     = local.tags
}
