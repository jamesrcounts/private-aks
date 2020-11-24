locals {
  aks_cluster_name = local.project
  project          = "private-aks"

  tags = {
    environment = local.project
  }
}

data "azurerm_client_config" "current" {}
resource "random_pet" "fido" {}
