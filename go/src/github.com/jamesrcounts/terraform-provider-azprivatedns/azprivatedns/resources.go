package azprivatedns

import "github.com/hashicorp/terraform-plugin-sdk/helper/schema"

func Resources() map[string]*schema.Resource {
	return map[string]*schema.Resource{
		"azprivatedns_resource_group_parse": resourceGroupParse(),
	}
}
