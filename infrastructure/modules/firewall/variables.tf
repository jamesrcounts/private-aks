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

variable "resource_group" {
  description = "(Required) The resource group to deploy networks into."
  type = object({
    name     = string
    location = string
    tags     = map(string)
  })
}

variable "subnet_id" {
  description = "(Required) The subnet id for the subnet dedicated to the Azure Firewall instance."
  type        = string
}
