module "configuration" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/configuration?ref=lz"

  backend_resource_group_name = var.backend_resource_group_name
}