variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the VWAN will be created"
}

variable "location" {
  type        = string
  description = "The location/region where the VWAN will be created"
}

variable "virtual_wan" {
  type = object({
    name                              = string
    type                              = optional(string, "Standard")
    disable_vpn_encryption            = optional(bool, false)
    allow_branch_to_branch_traffic    = optional(bool, true)
    office365_local_breakout_category = optional(string, "None")
  })
  description = <<DESCRIPTION
This variable defines the configuration for the virtual WAN.
- name: The name of the virtual WAN (string).
- type: The type of the virtual WAN (string).
- disable_vpn_encryption: Whether VPN encryption is disabled (bool).
- allow_branch_to_branch_traffic: Whether branch-to-branch traffic is allowed (bool).
- office365_local_breakout_category: The category for Office 365 local breakout (string).
DESCRIPTION

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,80}$", var.virtual_wan.name))
    error_message = "The virtual WAN name must be 1-80 characters long and can only contain letters, numbers, and hyphens."
  }

  validation {
    condition     = contains(["Basic", "Standard"], var.virtual_wan.type)
    error_message = "The virtual WAN type must be either 'Basic' or 'Standard'."
  }

  validation {
    condition     = contains(["None", "Optimize", "Allow", "Both"], var.virtual_wan.office365_local_breakout_category)
    error_message = "The Office 365 local breakout category must be one of: 'None', 'Optimize', 'Allow', 'Both'."
  }
}

variable "virtual_hubs" {
  type = map(object({
    virtual_hub_name                  = string
    virtual_wan_id                    = string
    location                          = string
    address_prefix                    = string
    routing_intent_name               = string
    firewall_name                     = string
    firewall_policy_name              = string
    firewall_zones                    = optional(set(string), ["1", "2", "3"])
    firewall_sku_tier                 = optional(string, "Premium")
    firewall_public_ip_count          = optional(number, 3)
    firewall_threat_intelligence_mode = optional(string, "Alert")
    firewall_dns_proxy_enabled        = optional(bool, true)
    firewall_dns_servers              = optional(set(string), ["168.63.129.16"]) # Default Azure DNS
    hub_bgp_peers = optional(map(object({
      name               = string
      peer_asn           = number
      peer_ip            = string
      vnet_connection_id = optional(string)
    })), {})
    tags = optional(map(string), {})
  }))

  description = <<DESCRIPTION
This variable defines the configuration for virtual hubs.

- virtual_hub_name: The name of the virtual hub (string).
- virtual_wan_id: The ID of the virtual WAN.
- location: The location/region of the virtual hub (string).
- address_prefix: The address prefix for the virtual hub (CIDR format).
- routing_intent_name: The name of the routing intent (string).
- firewall_name: The name of the firewall (string).
- firewall_policy_name: The name of the firewall policy (string).
- firewall_sku_tier: The SKU tier of the firewall (string). Defaults to "Premium".
- firewall_zones: Zones the firewall is deployed in. Defaults to ["1", "2", "3"] for HA.
- firewall_public_ip_count: The number of public IPs for the firewall (number). Defaults to 3.
- firewall_threat_intelligence_mode: The threat intelligence mode for the firewall (string). Defaults to "Alert".
- firewall_dns_proxy_enabled: Whether the firewall DNS proxy is enabled (bool). Defaults to "True".
- firewall_dns_servers: A list of DNS servers for the firewall (set of strings). Defaults to ["168.63.129.16"] (Azure DNS).
- hub_bgp_peers: A map of BGP peers, containing:
  - virtual_hub_id: The ID of the associated virtual hub.
  - name: The name of the BGP peer.
  - peer_asn: The ASN of the peer.
  - peer_ip: The IP address of the peer.
  - vnet_connection_id: (Optional) The ID of the associated VNet connection.
- tags: A map of tags to assign to the resource.
DESCRIPTION
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the resource."
}