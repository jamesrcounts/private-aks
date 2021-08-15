variable "resource_group" {
  description = "(Required) The resource group to deploy the policy into."
  type = object({
    name     = string
    location = string
    tags     = map(string)
  })
}

variable "subnet" {
  description = "(Required) The subnet to deploy the jumpbox into."
  type = object({
    id               = string
    address_prefixes = list(string)
  })
}