variable "firewall_policy_id" {
  default     = null
  description = "(Optional) The ID of the Firewall Policy applied to this Firewall."
  type        = string
}

variable "log_analytics_workspace" {
  description = "(Required) Specifies Log Analytics Workspace to use for diagnostics and workbooks."
  type = object({
    id                  = string
    name                = string
    resource_group_name = string
    subscription_id     = string
  })
}

variable "public_ip_prefix_id" {
  description = "(Required) Public IP address allocated will be provided from the public IP prefix resource."
  type        = string
}

variable "resource_group" {
  description = "(Required) The resource group to deploy networks into."
  type = object({
    name     = string
    location = string
    tags     = map(string)
  })
}

variable "route_table" {
  description = "(Required) This module will configure the route table with a route to send Internet traffic through the firewall."
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "subnet_id" {
  description = "(Required) The subnet id for the subnet dedicated to the Azure Firewall instance."
  type        = string
}
