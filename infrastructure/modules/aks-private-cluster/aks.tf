# az aks create \
# --resource-group $KUBE_GROUP \
# --name $KUBE_NAME \
# --load-balancer-sku standard \
# --vm-set-type VirtualMachineScaleSets \
# --enable-private-cluster \
# --network-plugin azure \
# --vnet-subnet-id $KUBE_AGENT_SUBNET_ID \
# --docker-bridge-address 172.17.0.1/16 \
# --dns-service-ip 10.2.0.10 \
# --service-cidr 10.2.0.0/24 \
# --enable-managed-identity \
# --assign-identity $MSI_RESOURCE_ID \
# --kubernetes-version $KUBE_VERSION \
# --outbound-type userDefinedRouting
resource "azurerm_kubernetes_cluster" "aks" {
  api_server_authorized_ip_ranges = []
  dns_prefix                      = local.instance_id
  enable_pod_security_policy      = false
  kubernetes_version              = data.azurerm_kubernetes_service_versions.current.latest_version
  location                        = var.resource_group.location
  name                            = "aks-${local.instance_id}"
  node_resource_group             = "${var.resource_group.name}-aks"
  private_cluster_enabled         = true
  private_dns_zone_id             = var.private_dns_zone_id
  resource_group_name             = var.resource_group.name
  sku_tier                        = "Free"
  tags                            = var.resource_group.tags

  addon_profile {
    aci_connector_linux { enabled = false }
    azure_policy { enabled = true }
    http_application_routing { enabled = false }
    kube_dashboard { enabled = false }
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics_workspace_id
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
    vnet_subnet_id        = var.subnet_id
  }

  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = var.user_assigned_identity_id
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
      admin_group_object_ids = [var.admin_group_object_id]
    }
  }

}





# TODO
# disk_encryption_set_id 
# https://docs.microsoft.com/en-us/azure/security-center/security-center-pricing
