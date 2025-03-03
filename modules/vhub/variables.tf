variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the VWAN will be created"
}

variable "virtual_hubs" {
  type = object({
    virtual_hub_name                            = string
    location                                    = string
    address_prefix                              = string
    routing_intent_name                         = string
    firewall_name                               = string
    firewall_zones                              = set(string)
    firewall_policy_name                        = string
    firewall_sku_tier                           = string
    firewall_public_ip_count                    = number
    firewall_threat_intelligence_mode           = string
    firewall_intrusion_detection_mode           = optional(string, "Alert")
    firewall_dns_proxy_enabled                  = bool
    firewall_dns_servers                        = list(string)
    firewall_intrusion_detection_private_ranges = optional(list(string), [])
    firewall_intrusion_detection_signature_overrides = optional(list(object({
      id    = string
      state = string
    })), [])
    firewall_intrusion_detection_traffic_bypass = optional(list(object({
      name                  = string
      protocol              = string
      description           = optional(string)
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
      destination_addresses = optional(list(string), [])
      destination_ports     = optional(list(string), [])
      destination_ip_groups = optional(list(string), [])
    })), [])
    firewall_intrusion_detection_tls_certificate = optional(list(object({
      key_vault_secret_id = string
      name                = string
    })), [])
  })
  description = <<DESCRIPTION
This variable defines the configuration for virtual hubs, including firewall settings, routing, and security configurations.

- virtual_hub_name: The name of the virtual hub (string).
- location: The Azure region where the virtual hub is deployed (string).
- address_prefix: The IP address prefix assigned to the virtual hub (string).
- routing_intent_name: The name of the routing intent associated with the hub (string).
- firewall_name: The name of the Azure Firewall deployed within the virtual hub (string).
- firewall_zones: Availability zones where the firewall is deployed (set of strings).
- firewall_policy_name: The name of the firewall policy applied to the firewall (string).
- firewall_sku_tier: The SKU tier of the firewall (e.g., "Standard" or "Premium") (string).
- firewall_public_ip_count: The number of public IPs allocated to the firewall (number).
- firewall_threat_intelligence_mode: The mode of threat intelligence for the firewall (string).
- firewall_intrusion_detection_mode: The mode of intrusion detection (e.g., "Alert" or "Deny") (optional, defaults to "Alert") (string).
- firewall_dns_proxy_enabled: Indicates whether the DNS proxy is enabled for the firewall (bool).
- firewall_dns_servers: A list of DNS servers configured for the firewall (list of strings).
- firewall_intrusion_detection_private_ranges: A list of private IP ranges for intrusion detection (optional, defaults to an empty list) (list of strings).
- firewall_intrusion_detection_signature_overrides: A list of firewall intrusion detection signature overrides (optional, defaults to an empty list).
  - id: The signature ID (string).
  - state: The override state for the signature (string).
- firewall_intrusion_detection_traffic_bypass: A list of rules for bypassing intrusion detection (optional, defaults to an empty list).
  - name: The name of the bypass rule (string).
  - protocol: The network protocol (e.g., "TCP", "UDP") (string).
  - description: A description of the bypass rule (optional) (string).
  - source_addresses: A list of source IP addresses (optional, defaults to an empty list) (list of strings).
  - source_ip_groups: A list of source IP groups (optional, defaults to an empty list) (list of strings).
  - destination_addresses: A list of destination IP addresses (optional, defaults to an empty list) (list of strings).
  - destination_ports: A list of destination ports (optional, defaults to an empty list) (list of strings).
  - destination_ip_groups: A list of destination IP groups (optional, defaults to an empty list) (list of strings).
- firewall_intrusion_detection_tls_certificate: A list of TLS certificates for intrusion detection (optional, defaults to an empty list).
  - key_vault_secret_id: The Key Vault secret ID storing the certificate (string).
  - name: The name of the TLS certificate (string).
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
