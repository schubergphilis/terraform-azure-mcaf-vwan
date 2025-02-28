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
}

variable "virtual_hubs" {
  type = map(object({
    virtual_hub_name                  = string
    address_prefix                    = string
    location                          = string
    routing_intent_name               = string
    firewall_name                     = string
    firewall_zones                    = optional(set(string), ["1", "2", "3"])
    firewall_policy_name              = string
    firewall_sku_tier                 = string
    firewall_public_ip_count          = number
    firewall_threat_intelligence_mode = string
    firewall_intrusion_detection_mode = string
    firewall_dns_proxy_enabled        = optional(bool, true)
    firewall_dns_servers              = list(string)
  }))
  default     = {}
  description = <<DESCRIPTION
This variable defines the configuration for virtual hubs.
- virtual_hub_name: The name of the virtual hub (string).
- location: The location/region of the virtual hub (string).
- address_prefix: The address prefix for the virtual hub (string).
- routing_intent_name: The name of the routing intent (string).
- firewall_name: The name of the firewall (string).
- firewall_policy_name: The name of the firewall policy (string).
- firewall_sku_tier: The SKU tier of the firewall (string).
- firewall_public_ip_count: The number of public IPs for the firewall (number).
- firewall_threat_intelligence_mode: The threat intelligence mode for the firewall (string).
- firewall_dns_proxy_enabled: Whether the firewall dns proxy is enabled (bool).
- firewall_dns_servers: A list of DNS servers for the firewall (list of string).
DESCRIPTION
}

variable "hub_bgp_peers" {
  type = map(object({
    virtual_hub_id     = string
    name               = string
    peer_asn           = number
    peer_ip            = string
    vnet_connection_id = string
  }))
  default     = {}
  description = <<DESCRIPTION
This variable defines the configuration for BGP peers.
- virtual_hub_id: The ID of the virtual hub (string).
- name: The name of the BGP peer (string).
- peer_asn: The ASN of the BGP peer (number).
- peer_ip: The IP address of the BGP peer (string).
- vnet_connection_id: The ID of the VNET Hub connection (string).
DESCRIPTION
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the resource."
}