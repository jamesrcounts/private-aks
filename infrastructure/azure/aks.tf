resource "azurerm_kubernetes_cluster" "aks" {
  name                            = local.aks_cluster_name
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  dns_prefix                      = local.project
  kubernetes_version              = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group             = "${azurerm_resource_group.main.name}-aks"
  sku_tier                        = "Free"
  api_server_authorized_ip_ranges = []
  enable_pod_security_policy      = false
  private_cluster_enabled         = false
  # private_link_enabled            = false

  addon_profile {
    aci_connector_linux { enabled = false }
    azure_policy { enabled = true }
    http_application_routing { enabled = false }
    kube_dashboard { enabled = false }
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
    }
  }

  auto_scaler_profile {
    balance_similar_node_groups      = false
    max_graceful_termination_sec     = 600
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scan_interval                    = "10s"
    scale_down_unneeded              = "10m"
    scale_down_unready               = "20m"
    scale_down_utilization_threshold = 0.5
  }

  default_node_pool {
    max_pods              = 100
    name                  = "system"
    orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
    os_disk_size_gb       = 1024
    type                  = "VirtualMachineScaleSets"
    vm_size               = "Standard_DS2_v2"
    availability_zones    = [1, 2, 3]
    enable_auto_scaling   = true
    enable_node_public_ip = false
    max_count             = 3
    min_count             = 1
  }

  identity { type = "SystemAssigned" }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed                = true
      admin_group_object_ids = [azuread_group.aks_administrators.object_id]
    }
  }

  tags = local.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  availability_zones    = [1, 2, 3]
  enable_auto_scaling   = true
  enable_node_public_ip = false
  max_pods              = 100
  mode                  = "User"
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb       = 1024
  os_type               = "Linux"
  priority              = "Regular"
  max_count             = 3
  min_count             = 1
  tags                  = local.tags
}

data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.main.location
}

# TODO
# disk_encryption_set_id 
# private_cluster_enabled 
# network_profile
# https://docs.microsoft.com/en-us/azure/security-center/security-center-pricing
