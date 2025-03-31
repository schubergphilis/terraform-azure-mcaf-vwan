variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the VWAN will be created"
}

variable "virtual_hub_name" {
  type        = string
  description = "The name of the virtual hub."
  validation {
    condition     = length(var.virtual_hub_name) > 0
    error_message = "virtual_hub_name must not be empty."
  }
}

variable "location" {
  type        = string
  description = "The Azure region where the virtual hub is deployed."
}

variable "address_prefix" {
  type        = string
  description = "The IP address prefix assigned to the virtual hub (e.g., '10.0.0.0/16')."
  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.address_prefix))
    error_message = "address_prefix must be a valid CIDR string (e.g., '10.0.0.0/16')."
  }
}

variable "routing_intent_name" {
  type        = string
  description = "The name of the routing intent associated with the virtual hub."
}

variable "firewall_name" {
  type        = string
  description = "The name of the Azure Firewall deployed within the virtual hub."
}

variable "firewall_zones" {
  type        = set(string)
  description = "Availability zones where the firewall is deployed (e.g., ['1', '2', '3'])."
}

variable "firewall_policy_name" {
  type        = string
  description = "The name of the firewall policy applied to the Azure Firewall."
}

variable "firewall_sku_tier" {
  type        = string
  description = "The SKU tier of the firewall (e.g., 'Standard' or 'Premium')."
  validation {
    condition     = contains(["Standard", "Premium"], var.firewall_sku_tier)
    error_message = "firewall_sku_tier must be either 'Standard' or 'Premium'."
  }
}

variable "firewall_public_ip_count" {
  type        = number
  description = "The number of public IPs allocated to the firewall."
  validation {
    condition     = var.firewall_public_ip_count >= 1 && var.firewall_public_ip_count <= 3
    error_message = "firewall_public_ip_count must be between 1 and 3."
  }
}

variable "firewall_threat_intelligence_mode" {
  type        = string
  description = "The mode of threat intelligence for the firewall (e.g., 'Alert', 'Deny', or 'Off')."
  validation {
    condition     = contains(["Alert", "Deny", "Off"], var.firewall_threat_intelligence_mode)
    error_message = "firewall_threat_intelligence_mode must be 'Alert', 'Deny', or 'Off'."
  }
}

variable "firewall_intrusion_detection_mode" {
  type        = string
  default     = "Alert"
  description = "The mode of intrusion detection (e.g., 'Alert' or 'Deny')."
  validation {
    condition     = contains(["Alert", "Deny"], var.firewall_intrusion_detection_mode)
    error_message = "firewall_intrusion_detection_mode must be 'Alert' or 'Deny'."
  }
}

variable "firewall_dns_proxy_enabled" {
  type        = bool
  description = "Indicates whether the DNS proxy is enabled for the firewall."
}

variable "firewall_dns_servers" {
  type        = list(string)
  description = "A list of DNS servers configured for the firewall."
}

variable "firewall_intrusion_detection_private_ranges" {
  type        = list(string)
  default     = []
  description = "A list of private IP ranges for intrusion detection."
}

variable "firewall_intrusion_detection_signature_overrides" {
  type = list(object({
    id    = string
    state = string
  }))
  default     = []
  description = "A list of firewall intrusion detection signature overrides."
}

variable "firewall_intrusion_detection_traffic_bypass" {
  type = list(object({
    name                  = string
    protocol              = string
    description           = optional(string)
    source_addresses      = optional(list(string), [])
    source_ip_groups      = optional(list(string), [])
    destination_addresses = optional(list(string), [])
    destination_ports     = optional(list(string), [])
    destination_ip_groups = optional(list(string), [])
  }))
  default     = []
  description = "A list of rules for bypassing intrusion detection."
}

variable "firewall_intrusion_detection_tls_certificate" {
  type = object({
    key_vault_secret_id = string
    name                = string
  })
  default     = null
  description = "TLS certificate used for intrusion detection (stored in Key Vault)."
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
