package azprivatedns

import (
	"fmt"
	"github.com/hashicorp/go-azure-helpers/authentication"

	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/terraform"
)

// Provider implements the Dns Zones data source
func Provider() terraform.ResourceProvider {
	p := &schema.Provider{
		DataSourcesMap: dataSourcesMap(),
		ResourcesMap:   resourcesMap(),

		Schema: map[string]*schema.Schema{
			// provider schema values taken from azurerm terraform provider
			"subscription_id": {
				Type:        schema.TypeString,
				Optional:    true,
				DefaultFunc: schema.EnvDefaultFunc("ARM_SUBSCRIPTION_ID", ""),
				Description: "The Subscription ID which should be used.",
			},

			"client_id": {
				Type:        schema.TypeString,
				Optional:    true,
				DefaultFunc: schema.EnvDefaultFunc("ARM_CLIENT_ID", ""),
				Description: "The Client ID which should be used.",
			},

			"tenant_id": {
				Type:        schema.TypeString,
				Optional:    true,
				DefaultFunc: schema.EnvDefaultFunc("ARM_TENANT_ID", ""),
				Description: "The Tenant ID which should be used.",
			},

			"client_secret": {
				Type:        schema.TypeString,
				Optional:    true,
				DefaultFunc: schema.EnvDefaultFunc("ARM_CLIENT_SECRET", ""),
				Description: "The Client Secret which should be used. For use When authenticating as a Service Principal using a Client Secret.",
			},
			"environment": {
				Type:        schema.TypeString,
				Optional:    true,
				DefaultFunc: schema.EnvDefaultFunc("ARM_ENVIRONMENT", "public"),
				Description: "(Optional) The Azure Environment which should be used. This can also be sourced from the ARM_ENVIRONMENT environment variable. Possible values are public, china, german, stack and usgovernment. Defaults to public.",
			},
		},
	}

	p.ConfigureFunc = initProvider(p)

	return p
}

func initProvider(p *schema.Provider) schema.ConfigureFunc {
	return func(d *schema.ResourceData) (interface{}, error) {
		builder := &authentication.Builder{
			SubscriptionID: d.Get("subscription_id").(string),
			ClientID:       d.Get("client_id").(string),
			ClientSecret:   d.Get("client_secret").(string),
			TenantID:       d.Get("tenant_id").(string),
			Environment:    d.Get("environment").(string),

			SupportsClientSecretAuth: true,
			SupportsAzureCliToken:    true,
		}

		config, err := builder.Build()
		if err != nil {
			return nil, fmt.Errorf("error building client auth: %v", err)
		}
		client, err := Build(config)
		if err != nil {
			return nil, fmt.Errorf("error building client: %v", err)
		}

		client.StopContext = p.StopContext()
		return client, nil
	}
}

// Resources constructs the resource schema for the provider.
func resourcesMap() map[string]*schema.Resource {
	return map[string]*schema.Resource{
		"azprivatedns_zones": zones(),
	}
}

func dataSourcesMap() map[string]*schema.Resource {
	return map[string]*schema.Resource{
		"azprivatedns_zones": dataSourcePrivateDNSZones(),
	}
}
