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
      * [x] jumpbox
    * [x] spoke 
      * [x] ingress
      * [x] aks agents
    * [x] peering between each
* [ ] UDR egress