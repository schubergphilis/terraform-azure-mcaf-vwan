variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}

variable "virtual_wan" {
  type = object({
    name     = string
    location = string
  })
}

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
