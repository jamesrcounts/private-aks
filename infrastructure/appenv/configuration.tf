module "configuration" {
  source = "../modules/configuration"

  backend_resource_group_name = var.backend_resource_group_name

  additional_imports = [
    "admin-group-object-id",
    "msi-resource-id",
    "subnets",
    "public-ip-prefix-id",
    "private-dns-zone-id",
  ]
}