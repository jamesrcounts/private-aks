package loafsley

import "github.com/hashicorp/terraform-plugin-sdk/helper/schema"

func Resources() map[string]*schema.Resource {
  return map[string]*schema.Resource{
    "loafsley_resource_group_parse": resourceGroupParse(),
  }
}
