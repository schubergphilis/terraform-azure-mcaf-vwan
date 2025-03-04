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
| <a name="input_location"></a> [location](#input\_location) | The location/region where the VWAN will be created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the VWAN will be created | `string` | n/a | yes |
| <a name="input_virtual_hubs"></a> [virtual\_hubs](#input\_virtual\_hubs) | This variable defines the configuration for virtual hubs, including firewall settings, routing, and security configurations.<br><br>- virtual\_hub\_name: The name of the virtual hub (string).<br>- location: The Azure region where the virtual hub is deployed (string).<br>- address\_prefix: The IP address prefix assigned to the virtual hub (string).<br>- routing\_intent\_name: The name of the routing intent associated with the hub (string).<br>- firewall\_name: The name of the Azure Firewall deployed within the virtual hub (string).<br>- firewall\_zones: Availability zones where the firewall is deployed (set of strings).<br>- firewall\_policy\_name: The name of the firewall policy applied to the firewall (string).<br>- firewall\_sku\_tier**: The SKU tier of the firewall (e.g., "Standard" or "Premium") (string).<br>- firewall\_public\_ip\_count: The number of public IPs allocated to the firewall (number).<br>- firewall\_threat\_intelligence\_mode: The mode of threat intelligence for the firewall (string).<br>- firewall\_intrusion\_detection\_mode: The mode of intrusion detection (e.g., "Alert" or "Deny") (optional, defaults to "Alert") (string).<br>- firewall\_dns\_proxy\_enabled: Indicates whether the DNS proxy is enabled for the firewall (bool).<br>- firewall\_dns\_servers**: A list of DNS servers configured for the firewall (list of strings).<br>- firewall\_intrusion\_detection\_private\_ranges: A list of private IP ranges for intrusion detection (optional, defaults to an empty list) (list of strings).<br>- firewall\_intrusion\_detection\_signature\_overrides: A list of firewall intrusion detection signature overrides (optional, defaults to an empty list).<br>  - id: The signature ID (string).<br>  - state: The override state for the signature (string).<br>- firewall\_intrusion\_detection\_traffic\_bypass: A list of rules for bypassing intrusion detection (optional, defaults to an empty list).<br>  - name: The name of the bypass rule (string).<br>  - protocol: The network protocol (e.g., "TCP", "UDP") (string).<br>  - description: A description of the bypass rule (optional) (string).<br>  - source\_addresses: A list of source IP addresses (optional, defaults to an empty list) (list of strings).<br>  - source\_ip\_groups: A list of source IP groups (optional, defaults to an empty list) (list of strings).<br>  - destination\_addresses: A list of destination IP addresses (optional, defaults to an empty list) (list of strings).<br>  - destination\_ports: A list of destination ports (optional, defaults to an empty list) (list of strings).<br>  - destination\_ip\_groups: A list of destination IP groups (optional, defaults to an empty list) (list of strings).<br>- firewall\_intrusion\_detection\_tls\_certificate: A list of TLS certificates for intrusion detection (optional, defaults to an empty list).<br>  - key\_vault\_secret\_id: The Key Vault secret ID storing the certificate (string).<br>  - name: The name of the TLS certificate (string). | <pre>map(object({<br>    virtual_hub_name                            = string<br>    address_prefix                              = string<br>    location                                    = string<br>    routing_intent_name                         = string<br>    firewall_name                               = string<br>    firewall_zones                              = optional(set(string), ["1", "2", "3"])<br>    firewall_policy_name                        = string<br>    firewall_sku_tier                           = string<br>    firewall_public_ip_count                    = number<br>    firewall_threat_intelligence_mode           = string<br>    firewall_intrusion_detection_mode           = optional(string, "Alert")<br>    firewall_dns_proxy_enabled                  = optional(bool, true)<br>    firewall_dns_servers                        = list(string)<br>    firewall_intrusion_detection_private_ranges = optional(list(string), [])<br>    firewall_intrusion_detection_signature_overrides = optional(list(object({<br>      id    = string<br>      state = string<br>    })), [])<br>    firewall_intrusion_detection_traffic_bypass = optional(list(object({<br>      name                  = string<br>      protocol              = string<br>      description           = optional(string)<br>      source_addresses      = optional(list(string), [])<br>      source_ip_groups      = optional(list(string), [])<br>      destination_addresses = optional(list(string), [])<br>      destination_ports     = optional(list(string), [])<br>      destination_ip_groups = optional(list(string), [])<br>    })), [])<br>    firewall_intrusion_detection_tls_certificate = optional(object({<br>      key_vault_secret_id = string<br>      name                = string<br>    }), null)<br>  }))</pre> | n/a | yes |
| <a name="input_virtual_wan"></a> [virtual\_wan](#input\_virtual\_wan) | This variable defines the configuration for the virtual WAN.<br>- name: The name of the virtual WAN (string).<br>- type: The type of the virtual WAN (string).<br>- disable\_vpn\_encryption: Whether VPN encryption is disabled (bool).<br>- allow\_branch\_to\_branch\_traffic: Whether branch-to-branch traffic is allowed (bool).<br>- office365\_local\_breakout\_category: The category for Office 365 local breakout (string). | <pre>object({<br>    name                              = string<br>    type                              = optional(string, "Standard")<br>    disable_vpn_encryption            = optional(bool, false)<br>    allow_branch_to_branch_traffic    = optional(bool, true)<br>    office365_local_breakout_category = optional(string, "None")<br>  })</pre> | n/a | yes |
| <a name="input_hub_bgp_peers"></a> [hub\_bgp\_peers](#input\_hub\_bgp\_peers) | This variable defines the configuration for BGP peers.<br>- virtual\_hub\_id: The ID of the virtual hub (string).<br>- name: The name of the BGP peer (string).<br>- peer\_asn: The ASN of the BGP peer (number).<br>- peer\_ip: The IP address of the BGP peer (string).<br>- vnet\_connection\_id: The ID of the VNET Hub connection (string). | <pre>map(object({<br>    virtual_hub_id     = string<br>    name               = string<br>    peer_asn           = number<br>    peer_ip            = string<br>    vnet_connection_id = string<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | ID of the Resource Group created by the module |
<!-- END_TF_DOCS -->