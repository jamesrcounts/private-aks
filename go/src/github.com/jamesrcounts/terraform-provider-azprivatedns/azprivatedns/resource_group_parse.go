package azprivatedns

import (
	"fmt"

	"github.com/Azure/azure-sdk-for-go/services/dns/mgmt/2018-05-01/dns"
	"github.com/Azure/azure-sdk-for-go/services/network/mgmt/2019-09-01/network"
	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
	uuid "github.com/satori/go.uuid"
)

func resourceGroupParse() *schema.Resource {
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

			"network_security_groups": &schema.Schema{
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
	nsgClient := m.(*Client).SecurityGroupsClient
	routeTableClient := m.(*Client).RouteTablesClient
	zonesClient := m.(*Client).ZonesClient
	ctx := m.(*Client).StopContext

	resourceGroupName := d.Get("resource_group_name").(string)

	nsgList, err := nsgClient.List(ctx, resourceGroupName)
	if err != nil {
		return fmt.Errorf("error listing security groups: %v", err)
	}
	err = d.Set("network_security_groups", flattenNetworkSecurityGroups(nsgList))
	if err != nil {
		return fmt.Errorf("error setting state network security groups: %v", err)
	}

	routeTablesList, err := routeTableClient.List(ctx, resourceGroupName)
	if err != nil {
		return fmt.Errorf("error listing route tables: %v", err)
	}
	err = d.Set("route_tables", flattenRouteTables(routeTablesList))
	if err != nil {
		return fmt.Errorf("error setting state route tables: %v", err)
	}

	dnsZonesList, err := zonesClient.ListByResourceGroup(ctx, resourceGroupName, nil)
	if err != nil {
		return fmt.Errorf("error listing dns zones: %v", err)
	}
	err = d.Set("dns_zones", flattenDNSZones(dnsZonesList))
	if err != nil {
		return fmt.Errorf("error settng state dns zones: %v", err)
	}

	return nil
}

func flattenNetworkSecurityGroups(groupList network.SecurityGroupListResultPage) []interface{} {
	groups := groupList.Values()
	nsgs := make([]interface{}, 0)
	for _, n := range groups {
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

func flattenDNSZones(zoneList dns.ZoneListResultPage) []interface{} {
	zones := zoneList.Values()
	results := make([]interface{}, 0)
	for _, n := range zones {
		result := make(map[string]string)
		if n.ID != nil {
			result["id"] = *n.ID
		}

		if n.Name != nil {
			result["name"] = *n.Name
		}
		results = append(results, result)
	}

	return results
}
