# az aks create \
# --resource-group $KUBE_GROUP \
# --name $KUBE_NAME \
# --load-balancer-sku standard \
# --vm-set-type VirtualMachineScaleSets \
# --enable-private-cluster \
# --network-plugin kubenet \
# --vnet-subnet-id $KUBE_AGENT_SUBNET_ID \
# --docker-bridge-address 172.17.0.1/16 \
# --dns-service-ip 10.2.0.10 \
# --service-cidr 10.2.0.0/24 \
# --service-principal $SERVICE_PRINCIPAL_ID \
# --client-secret $SERVICE_PRINCIPAL_SECRET \
# --kubernetes-version $KUBE_VERSION \
# --outbound-type userDefinedRouting
resource "azurerm_kubernetes_cluster" "aks" {
  depends_on = [
    azurerm_role_assignment.aks_vnet_contributor,
    azurerm_subnet_route_table_association.aks
  ]

  name                            = local.aks_cluster_name
  location                        = data.azurerm_resource_group.main.location
  resource_group_name             = data.azurerm_resource_group.main.name
  dns_prefix                      = local.project
  kubernetes_version              = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group             = local.aks_node_resource_group
  sku_tier                        = "Free"
  api_server_authorized_ip_ranges = []
  enable_pod_security_policy      = false
  private_cluster_enabled         = true

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
    availability_zones    = [1, 2, 3]
    enable_auto_scaling   = true
    enable_node_public_ip = false
    max_count             = 3
    max_pods              = 100
    min_count             = 1
    name                  = "system"
    orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
    os_disk_size_gb       = 1024
    type                  = "VirtualMachineScaleSets"
    vm_size               = "Standard_DS2_v2"
    vnet_subnet_id        = local.subnet_id_agents
  }

  service_principal {
    client_id     = azuread_service_principal.aks_principal.application_id
    client_secret = random_password.password.result
  }

  network_profile {
    dns_service_ip     = "10.2.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    load_balancer_sku  = "Standard"
    network_plugin     = "kubenet"
    outbound_type      = "userDefinedRouting"
    service_cidr       = "10.2.0.0/24"
  }

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
  availability_zones    = [1, 2, 3]
  enable_auto_scaling   = true
  enable_node_public_ip = false
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  max_count             = 3
  max_pods              = 100
  min_count             = 1
  mode                  = "User"
  name                  = "user"
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb       = 1024
  os_type               = "Linux"
  priority              = "Regular"
  tags                  = local.tags
  vm_size               = "Standard_DS2_v2"
  vnet_subnet_id        = local.subnet_id_agents
}

data "azurerm_kubernetes_service_versions" "current" {
  location = data.azurerm_resource_group.main.location
}

# TODO
# disk_encryption_set_id 
# https://docs.microsoft.com/en-us/azure/security-center/security-center-pricing
