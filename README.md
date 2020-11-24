# Private AKS Cluster with Terraform

## Steps

### Basic

* [x] Create a resource group
* [x] Create cluster with private cluster flag = `true`
* [x] Use azure networking plugin

### Advanced
* [ ] Bring your own network
  * [x] Resource group for network
  * [x] Pair of virtual networks
    * [x] hub
      * [x] AzureFirewallSubnet
        * [x] Azure Firewall with rules required by AKS
      * [x] jumpbox
      * [x] Public IP block
    * [x] spoke 
      * [x] ingress
      * [x] aks agents
        * [x] route table and route to firewall
    * [x] peering between each
* [ ] UDR egress