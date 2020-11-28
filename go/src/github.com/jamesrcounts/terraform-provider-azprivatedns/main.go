package main

import (
  "github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
  "github.com/hashicorp/terraform-plugin-sdk/v2/plugin"

  "terraform-provider-azprivatedns/azprivatedns"
)

func main() {
  plugin.Serve(&plugin.ServeOpts{
    ProviderFunc: func() *schema.Provider {
      return azprivatedns.Provider()
    },
  })
}
