resource "azurerm_storage_account" "diagnostics" {
  name                      = substr(replace("sa-${local.project}-diagnostics-${random_pet.fido.id}", "-", ""), 0, 24)
  resource_group_name       = data.azurerm_resource_group.main.name
  location                  = data.azurerm_resource_group.main.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  access_tier               = "Cool"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
  is_hns_enabled            = false
  large_file_share_enabled  = false

  identity {
    type = "SystemAssigned"
  }

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  network_rules {
    bypass = [
      "AzureServices",
    ]
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  tags = local.tags
}

#TODO
# network rules - azurerm_storage_account_network_rules
