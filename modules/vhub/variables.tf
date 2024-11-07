variable "virtual_hubs" {
  type = object({
    name                     = string
    location                 = string
    address_prefix           = string
    firewall_sku_tier        = string
    firewall_public_ip_count = number
  })
}

variable "virtual_wan_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}