variable "additional_imports" {
  default     = []
  description = "(Optional) Additional keys to lookup in the configuration store"
  type        = list(string)
}

variable "backend_resource_group_name" {
  description = "(Required) The backend resource group that supports this environment."
  type        = string
}