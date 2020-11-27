## Terraform Provider

Custom terraform provider to parse private dns zones in an Azure resource group.

## Example


```
resource "az_private_dns_helper" "test"
  resource_group_name = "some-resource-group-name"
}
```

In this example, `az_private_dns_helper.test` has one attribute `private_dns_zones`. The attribute has `name` and `id` properties.
