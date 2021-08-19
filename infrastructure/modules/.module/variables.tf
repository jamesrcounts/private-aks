variable "resource_group" {
  description = "(Required) The resource group to deploy the policy into."
  type = object({
    name     = string
    location = string
    tags     = map(string)
  })
}
