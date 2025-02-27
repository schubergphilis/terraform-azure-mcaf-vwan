# terraform-azure-mcaf-vwan

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4, < 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vhub"></a> [vhub](#module\_vhub) | ./modules/vhub | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_virtual_hub_bgp_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_bgp_connection) | resource |
| [azurerm_virtual_wan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_wan) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | n/a | <pre>object({<br>    name     = string<br>    location = string<br>  })</pre> | n/a | yes |
| <a name="input_virtual_wan"></a> [virtual\_wan](#input\_virtual\_wan) | This variable defines the configuration for the virtual WAN.<br>- name: The name of the virtual WAN (string).<br>- type: The type of the virtual WAN (string).<br>- disable\_vpn\_encryption: Whether VPN encryption is disabled (bool).<br>- allow\_branch\_to\_branch\_traffic: Whether branch-to-branch traffic is allowed (bool).<br>- office365\_local\_breakout\_category: The category for Office 365 local breakout (string). | <pre>object({<br>    name                              = string<br>    type                              = optional(string, "Standard")<br>    disable_vpn_encryption            = optional(bool, false)<br>    allow_branch_to_branch_traffic    = optional(bool, true)<br>    office365_local_breakout_category = optional(string, "None")<br>  })</pre> | n/a | yes |
| <a name="input_hub_bgp_peers"></a> [hub\_bgp\_peers](#input\_hub\_bgp\_peers) | This variable defines the configuration for BGP peers.<br>- virtual\_hub\_id: The ID of the virtual hub (string).<br>- name: The name of the BGP peer (string).<br>- peer\_asn: The ASN of the BGP peer (number).<br>- peer\_ip: The IP address of the BGP peer (string).<br>- vnet\_connection\_id: The ID of the VNET Hub connection (string). | <pre>map(object({<br>    virtual_hub_id     = string<br>    name               = string<br>    peer_asn           = number<br>    peer_ip            = string<br>    vnet_connection_id = string<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_virtual_hubs"></a> [virtual\_hubs](#input\_virtual\_hubs) | This variable defines the configuration for virtual hubs.<br>- virtual\_hub\_name: The name of the virtual hub (string).<br>- location: The location/region of the virtual hub (string).<br>- address\_prefix: The address prefix for the virtual hub (string).<br>- routing\_intent\_name: The name of the routing intent (string).<br>- firewall\_name: The name of the firewall (string).<br>- firewall\_policy\_name: The name of the firewall policy (string).<br>- firewall\_sku\_tier: The SKU tier of the firewall (string).<br>- firewall\_public\_ip\_count: The number of public IPs for the firewall (number).<br>- firewall\_threat\_intelligence\_mode: The threat intelligence mode for the firewall (string).<br>- firewall\_dns\_proxy\_enabled: Whether the firewall dns proxy is enabled (bool).<br>- firewall\_dns\_servers: A list of DNS servers for the firewall (list of string). | <pre>map(object({<br>    virtual_hub_name                  = string<br>    address_prefix                    = string<br>    location                          = string<br>    routing_intent_name               = string<br>    firewall_name                     = string<br>    firewall_zones                    = optional(set(string), ["1", "2", "3"])<br>    firewall_policy_name              = string<br>    firewall_sku_tier                 = string<br>    firewall_public_ip_count          = number<br>    firewall_threat_intelligence_mode = string<br>    firewall_dns_proxy_enabled        = optional(bool, true)<br>    firewall_dns_servers              = list(string)<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->