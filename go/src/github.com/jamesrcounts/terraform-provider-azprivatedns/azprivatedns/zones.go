package azprivatedns

import (
	"fmt"

	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
	uuid "github.com/satori/go.uuid"
)

func zones() *schema.Resource {
	return &schema.Resource{
		Create: resourceServerCreate,
		Read:   resourceServerRead,
		Update: resourceServerRead,
		Delete: resourceServerRead,

		Schema: map[string]*schema.Schema{
			"resource_group_name": &schema.Schema{
				Type:     schema.TypeString,
				Required: true,
			},

			"dns_zones": &schema.Schema{
				Type:     schema.TypeList,
				Computed: true,
				Elem: &schema.Resource{
					Schema: map[string]*schema.Schema{
						"name": {
							Type:     schema.TypeString,
							Optional: true,
						},
						"id": {
							Type:     schema.TypeString,
							Optional: true,
						},
					},
				},
			},
		},
	}
}

func resourceServerCreate(d *schema.ResourceData, m interface{}) error {
	id := uuid.NewV4()
	d.SetId(id.String())
	return resourceServerRead(d, m)
}

func resourceServerRead(d *schema.ResourceData, m interface{}) error {
	zonesClient := m.(*Client).PrivateZonesClient
	ctx := m.(*Client).StopContext

	resourceGroupName := d.Get("resource_group_name").(string)

	zonesIterator, err := zonesClient.ListByResourceGroupComplete(ctx, resourceGroupName, nil)
	if err != nil {
		return fmt.Errorf("listing DNS Zones: %+v", err)
	}

	results := make([]interface{}, 0)
	for zonesIterator.NotDone() {
		zone := zonesIterator.Value()
		if zone.Name != nil && zone.ID != nil {
			result := make(map[string]string)
			result["id"] = *zone.ID
			result["name"] = *zone.Name
			results = append(results, result)
		}
		if err := zonesIterator.NextWithContext(ctx); err != nil {
			return fmt.Errorf("listing DNS Zones: %+v", err)
		}
	}

	err = d.Set("dns_zones", results)
	if err != nil {
		return fmt.Errorf("error settng state dns zones: %v", err)
	}

	return nil
}
