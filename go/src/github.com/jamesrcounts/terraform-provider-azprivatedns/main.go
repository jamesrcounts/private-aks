package main

import (
	"github.com/hashicorp/terraform-plugin-sdk/plugin"
	"github.com/hashicorp/terraform-plugin-sdk/terraform"
	"terraform-provider-azprivatedns/azprivatedns"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: func() terraform.ResourceProvider {
			return azprivatedns.Provider()
		},
	})
}
