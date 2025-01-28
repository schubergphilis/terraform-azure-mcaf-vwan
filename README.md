# terraform-azure-mcaf-vwan

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4 |

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
| <a name="input_virtual_hubs"></a> [virtual\_hubs](#input\_virtual\_hubs) | n/a | <pre>map(object({<br>    virtual_hub_name                  = string<br>    location                          = string<br>    address_prefix                    = string<br>    routing_intent_name               = string<br>    firewall_name                     = string<br>    firewall_policy_name              = string<br>    firewall_sku_tier                 = string<br>    firewall_public_ip_count          = number<br>    firewall_threat_intelligence_mode = string<br>    firewall_proxy_enabled            = bool<br>    firewall_dns_servers              = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_virtual_wan"></a> [virtual\_wan](#input\_virtual\_wan) | n/a | <pre>object({<br>    name     = string<br>    location = string<br>  })</pre> | n/a | yes |
| <a name="input_hub_bgp_peers"></a> [hub\_bgp\_peers](#input\_hub\_bgp\_peers) | n/a | <pre>map(object({<br>    virtual_hub_id     = string<br>    name               = string<br>    peer_asn           = number<br>    peer_ip            = string<br>    vnet_connection_id = string<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->