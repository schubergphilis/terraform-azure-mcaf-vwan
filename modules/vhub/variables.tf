variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the VWAN will be created"
}

variable "virtual_hubs" {
  type = object({
    virtual_hub_name                  = string
    location                          = string
    address_prefix                    = string
    routing_intent_name               = string
    firewall_name                     = string
    firewall_zones                    = set(string)
    firewall_policy_name              = string
    firewall_sku_tier                 = string
    firewall_public_ip_count          = number
    firewall_public_ip_id             = string
    firewall_public_ip_name           = string
    firewall_threat_intelligence_mode = string
    firewall_dns_proxy_enabled        = bool
    firewall_dns_servers              = list(string)
  })
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

variable "virtual_wan_id" {
  type        = string
  description = "The ID of the virtual WAN."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the resource."
}