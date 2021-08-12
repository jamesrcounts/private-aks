variable "log_analytics_workspace" {
  description = "(Required) Specifies Log Analytics Workspace to use for diagnostics and workbooks."
  type = object({
    subscription_id     = string
    resource_group_name = string
    name                = string
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
