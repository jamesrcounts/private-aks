module "configuration" {
  source = "../modules/configuration"

  additional_imports          = ["private-dns-zone-id", "public-ip-prefix-id", "subnets"]
  backend_resource_group_name = var.backend_resource_group_name
}