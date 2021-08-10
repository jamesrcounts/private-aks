variable "log_analytics_workspace_id" {
  description = "(Required) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
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

variable "subnet_id" {
  description = "(Required) The subnet id for the subnet dedicated to the Azure Firewall instance."
  type        = string
}