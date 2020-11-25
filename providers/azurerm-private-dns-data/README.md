## Terraform Provider

Custom terraform provider to parse resources in an Azure resource group.

## Example


```
resource "loafsley_resource_group_parse" "test"
  resource_group_name = "some-resource-group-name"
}
```

In this example, `loafsley_resource_group_parse.test` has two attributes `network_security_groups` and `route_tables`. Each attribute has `name` and `id` properties.
