# az network public-ip create -g $VNET_GROUP -n $DEPLOYMENT_NAME --sku Standard
resource "azurerm_public_ip" "firewall" {
  allocation_method   = "Static"
  sku                 = "Standard"
  location            = azurerm_resource_group.net.location
  name                = local.project
  public_ip_prefix_id = azurerm_public_ip_prefix.hub.id
  resource_group_name = azurerm_resource_group.net.name
  tags                = local.tags
}

# az network firewall create --name $DEPLOYMENT_NAME --resource-group $VNET_GROUP --location $LOCATION
# az network firewall ip-config create --firewall-name $DEPLOYMENT_NAME --name $DEPLOYMENT_NAME --public-ip-address $DEPLOYMENT_NAME --resource-group $VNET_GROUP --vnet-name $HUB_VNET_NAME
resource "azurerm_firewall" "fw" {
  name                = local.firewall_name
  location            = azurerm_resource_group.net.location
  resource_group_name = azurerm_resource_group.net.name

  ip_configuration {
    name                 = "${local.firewall_name}-ip-config"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

# FW_PRIVATE_IP=$(az network firewall show -g $VNET_GROUP -n $DEPLOYMENT_NAME --query "ipConfigurations[0].privateIpAddress" -o tsv)
# az monitor log-analytics workspace create --resource-group $VNET_GROUP --workspace-name $DEPLOYMENT_NAME --location $LOCATION

# az network firewall network-rule create \
#   --firewall-name $DEPLOYMENT_NAME \
#   --collection-name "time" \
#   --destination-addresses "*" \
#   --destination-ports 123 \
#   --name "allow network" \
#   --protocols "UDP" \
#   --resource-group $VNET_GROUP \
#   --source-addresses "*" \
#   --action "Allow" \
#   --description "aks node time sync rule" \
#   --priority 101
resource "azurerm_firewall_network_rule_collection" "time" {
  name                = "time"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.net.name
  priority            = 101
  action              = "Allow"

  rule {
    name        = "allow network"
    description = "AKS node time sync rule"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "123",
    ]

    destination_addresses = [
      "*",
    ]

    protocols = [
      "UDP",
    ]
  }
}

# az network firewall network-rule create \
# --firewall-name $DEPLOYMENT_NAME \
# --collection-name "dns" \
# --destination-addresses "*"  \
# --destination-ports 53 \
# --name "allow network" \
# --protocols "UDP" \
# --resource-group $VNET_GROUP \
# --source-addresses "*" \
# --action "Allow" \
# --description "aks node dns rule" \
# --priority 102
resource "azurerm_firewall_network_rule_collection" "dns" {
  name                = "dns"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.net.name
  priority            = 102
  action              = "Allow"

  rule {
    name        = "allow network"
    description = "AKS node dns rule"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "53",
    ]

    destination_addresses = [
      "*",
    ]

    protocols = [
      "UDP",
    ]
  }
}

# az network firewall network-rule create \
# --firewall-name $DEPLOYMENT_NAME \
# --collection-name "servicetags" \
# --destination-addresses "AzureContainerRegistry" "MicrosoftContainerRegistry" "AzureActiveDirectory" "AzureMonitor" \
# --destination-ports "*" \
# --name "allow service tags" \
# --protocols "Any" \
# --resource-group $VNET_GROUP \
# --source-addresses "*" \
# --action "Allow" \
# --description "allow service tags" \
# --priority 110
resource "azurerm_firewall_network_rule_collection" "servicetags" {
  name                = "servicetags"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.net.name
  priority            = 110
  action              = "Allow"

  rule {
    name        = "allow service tags"
    description = "Allow service tags"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "*",
    ]

    destination_addresses = [
      "AzureActiveDirectory",
      "AzureContainerRegistry",
      "AzureMonitor",
      "MicrosoftContainerRegistry",
    ]

    protocols = [
      "Any",
    ]
  }
}

# az network firewall application-rule create \
# --firewall-name $DEPLOYMENT_NAME \
# --resource-group $VNET_GROUP \
# --collection-name 'aksfwar' -n 'fqdn' \
# --source-addresses '*' \
# --protocols 'http=80' 'https=443' \
# --fqdn-tags "AzureKubernetesService" \
# --action allow \
# --priority 101
resource "azurerm_firewall_application_rule_collection" "aks" {
  name                = "aks"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.net.name
  priority            = 101
  action              = "Allow"

  rule {
    name = "fqdn"

    source_addresses = [
      "*",
    ]

    target_fqdns = [
      "AzureKubernetesService",
    ]

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "443"
      type = "Https"
    }
  }
}

# az network firewall application-rule create  \
# --firewall-name $DEPLOYMENT_NAME \
# --collection-name "osupdates" \
# --name "allow network" \
# --protocols http=80 https=443 \
# --source-addresses "*" \
# --resource-group $VNET_GROUP \
# --action "Allow" \
# --target-fqdns "download.opensuse.org" "security.ubuntu.com" "packages.microsoft.com" "azure.archive.ubuntu.com" "changelogs.ubuntu.com" "snapcraft.io" "api.snapcraft.io" "motd.ubuntu.com"  \
# --priority 102
resource "azurerm_firewall_application_rule_collection" "os_updates" {
  name                = "os-updates"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.net.name
  priority            = 102
  action              = "Allow"

  rule {
    name = "allow network"

    source_addresses = [
      "*",
    ]

    target_fqdns = [
      "api.snapcraft.io",
      "azure.archive.ubuntu.com",
      "changelogs.ubuntu.com",
      "download.opensuse.org",
      "motd.ubuntu.com",
      "packages.microsoft.com",
      "security.ubuntu.com",
      "snapcraft.io",
    ]

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "443"
      type = "Https"
    }
  }
}