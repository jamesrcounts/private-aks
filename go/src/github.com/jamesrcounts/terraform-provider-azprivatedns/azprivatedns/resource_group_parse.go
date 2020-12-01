package azprivatedns

import (
	"fmt"

	"github.com/Azure/azure-sdk-for-go/services/network/mgmt/2019-09-01/network"
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

			"route_tables": &schema.Schema{
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
	routeTableClient := m.(*Client).RouteTablesClient
	zonesClient := m.(*Client).PrivateZonesClient
	ctx := m.(*Client).StopContext

	resourceGroupName := d.Get("resource_group_name").(string)

	routeTablesList, err := routeTableClient.List(ctx, resourceGroupName)
	if err != nil {
		return fmt.Errorf("error listing route tables: %v", err)
	}
	err = d.Set("route_tables", flattenRouteTables(routeTablesList))
	if err != nil {
		return fmt.Errorf("error setting state route tables: %v", err)
	}

	// DNS
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

func flattenRouteTables(tableList network.RouteTableListResultPage) []interface{} {
	tables := tableList.Values()
	nsgs := make([]interface{}, 0)
	for _, n := range tables {
		nsg := make(map[string]string)
		if n.ID != nil {
			nsg["id"] = *n.ID
		}

		if n.Name != nil {
			nsg["name"] = *n.Name
		}
		nsgs = append(nsgs, nsg)
	}

	return nsgs
}
