variable "admin_group_object_id" {
  description = "(Required) An Object ID of the Azure Active Directory Groups which should have Admin Role on the Cluster."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "(Required) Specifies Log Analytics Workspace ID to use for diagnostics and workbooks."
  type        = string
}

variable "resource_group" {
  description = "(Required) The resource group to deploy the policy into."
  type = object({
    name     = string
    location = string
    tags     = map(string)
  })
}

variable "subnet_id" {
  description = "(Required) The subnet id for the AKS nodes to use."
  type        = string
}

variable "user_assigned_identity_id" {
  description = "(Required) The ID of a user assigned identity."
  type        = string
}

