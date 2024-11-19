variable "virtual_hubs" {
  type = object({
    virtual_hub_name                  = string
    location                 = string
    address_prefix           = string
    routing_intent_name      = string
    firewall_name            = string
    firewall_sku_tier        = string
    firewall_public_ip_count = number
    firewall_threat_intelligence_mode = string
    firewall_proxy_enabled   = bool
    firewall_dns_servers     = list(string)

  })
}

variable "virtual_wan_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}