resource "azurerm_firewall_policy_rule_collection_group" "rules" {
  name               = "afwprg-aks"
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = 500

  # az network firewall application-rule create \
  # --firewall-name $DEPLOYMENT_NAME \
  # --resource-group $VNET_GROUP \
  # --collection-name 'aksfwar' -n 'fqdn' \
  # --source-addresses '*' \
  # --protocols 'http=80' 'https=443' \
  # --fqdn-tags "AzureKubernetesService" \
  # --action allow \
  # --priority 101
  application_rule_collection {
    name     = "aks"
    priority = 128
    action   = "Allow"

    rule {
      name = "fqdn-tag"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses      = ["*"]
      destination_fqdn_tags = ["AzureKubernetesService"]
    }

    rule {
      name = "fqdn"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["*"]
      destination_fqdns = [
        "data.policy.core.windows.net",
        "store.policy.core.windows.net",
        "dc.services.visualstudio.com"
      ]
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
  application_rule_collection {
    name     = "os-updates"
    priority = 129
    action   = "Allow"

    rule {
      name = "fqdn"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["*"]
      destination_fqdns = [
        "api.snapcraft.io",
        "azure.archive.ubuntu.com",
        "changelogs.ubuntu.com",
        "download.opensuse.org",
        "motd.ubuntu.com",
        "packages.microsoft.com",
        "security.ubuntu.com",
        "snapcraft.io",
      ]
    }
  }

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

  network_rule_collection {
    name     = "time"
    priority = 101
    action   = "Allow"

    rule {
      name                  = "aks-node-time-sync"
      protocols             = ["UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["123"]
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
  network_rule_collection {
    name     = "dns"
    priority = 102
    action   = "Allow"

    rule {
      name                  = "aks-node-dns"
      protocols             = ["UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["53"]
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
  network_rule_collection {
    name     = "servicetags"
    priority = 110
    action   = "Allow"

    rule {
      name             = "allow-service-tags"
      protocols        = ["Any"]
      source_addresses = ["*"]
      destination_addresses = [
        "AzureActiveDirectory",
        "AzureContainerRegistry",
        "AzureMonitor",
        "MicrosoftContainerRegistry",
      ]
      destination_ports = ["*"]
    }
  }
}