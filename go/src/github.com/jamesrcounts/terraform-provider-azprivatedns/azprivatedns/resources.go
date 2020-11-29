package azprivatedns

import "github.com/hashicorp/terraform-plugin-sdk/helper/schema"

// Resources constructs the resource schema for the provider.
func Resources() map[string]*schema.Resource {
	return map[string]*schema.Resource{
		"az_dns_zones": resourceGroupParse(),
	}
}
