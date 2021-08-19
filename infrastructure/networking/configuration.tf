module "configuration" {
  source = "github.com/jamesrcounts/private-aks.git//infrastructure/modules/configuration?ref=2021.08"

  backend_resource_group_name = var.backend_resource_group_name
}