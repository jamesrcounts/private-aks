module "configuration" {
  source                      = "../modules/configuration"
  backend_resource_group_name = var.backend_resource_group_name
}