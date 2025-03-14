
# This Terraform configuration defines resources for an Azure Virtual Hub setup, including:
# - azurerm_virtual_hub: Represents a Virtual Hub in Azure Virtual WAN.
# - azurerm_virtual_hub_routing_intent: Defines routing policies for the Virtual Hub.
# - azurerm_firewall: Configures an Azure Firewall associated with the Virtual Hub.
# - azurerm_firewall_policy: Specifies the Firewall Policy for the Azure Firewall.


resource "azurerm_virtual_hub" "this" {
  name                = var.virtual_hubs.virtual_hub_name
  resource_group_name = var.resource_group_name
  location            = var.virtual_hubs.location
  address_prefix      = var.virtual_hubs.address_prefix
  virtual_wan_id      = var.virtual_wan_id

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Virtual Hub"
    })
  )
}

resource "azurerm_firewall" "this" {
  name                = var.virtual_hubs.firewall_name
  resource_group_name = var.resource_group_name
  location            = var.virtual_hubs.location
  sku_name            = "AZFW_Hub"
  sku_tier            = var.virtual_hubs.firewall_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.this.id
  zones               = var.virtual_hubs.firewall_zones


  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.this.id
    public_ip_count = var.virtual_hubs.use_byoip ? max(var.virtual_hubs.firewall_public_ip_count, 1) : var.virtual_hubs.firewall_public_ip_count
  }

  dynamic "ip_configuration" {
    for_each = var.virtual_hubs.use_byoip ? var.virtual_hubs.byoip_public_ip_ids : []
    content {
      name                 = "byoip-${index(var.virtual_hubs.byoip_public_ip_ids, ip_configuration.value)}"
      public_ip_address_id = ip_configuration.value
    }
  }

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Firewall"
    })
  )
}

# Create Public IP resources if BYOIP is enabled
resource "azurerm_public_ip" "firewall_public_ip" {
  count = var.virtual_hubs.use_byoip && length(var.virtual_hubs.byoip_public_ip_ids) == 0 ? var.virtual_hubs.firewall_public_ip_count : 0

  name                = "${var.virtual_hubs.firewall_name}-pip-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.virtual_hubs.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Public IP"
    })
  )
}

resource "azurerm_firewall_policy" "this" {
  name                     = var.virtual_hubs.firewall_policy_name
  resource_group_name      = var.resource_group_name
  location                 = var.virtual_hubs.location
  sku                      = var.virtual_hubs.firewall_sku_tier
  threat_intelligence_mode = var.virtual_hubs.firewall_threat_intelligence_mode

  dynamic "intrusion_detection" {
    for_each = var.virtual_hubs.firewall_sku_tier == "Premium" ? [1] : []
    content {
      mode           = var.virtual_hubs.firewall_intrusion_detection_mode
      private_ranges = try(var.virtual_hubs.firewall_intrusion_detection_private_ranges, [])

      dynamic "signature_overrides" {
        for_each = try(var.virtual_hubs.firewall_intrusion_detection_signature_overrides, [])
        content {
          id    = signature_overrides.value.id
          state = signature_overrides.value.state
        }
      }

      dynamic "traffic_bypass" {
        for_each = try(var.virtual_hubs.firewall_intrusion_detection_traffic_bypass, [])
        content {
          name                  = traffic_bypass.value.name
          protocol              = traffic_bypass.value.protocol
          description           = try(traffic_bypass.value.description, null)
          source_addresses      = try(traffic_bypass.value.source_addresses, [])
          source_ip_groups      = try(traffic_bypass.value.source_ip_groups, [])
          destination_addresses = try(traffic_bypass.value.destination_addresses, [])
          destination_ports     = try(traffic_bypass.value.destination_ports, [])
          destination_ip_groups = try(traffic_bypass.value.destination_ip_groups, [])
        }
      }
    }
  }

  dynamic "tls_certificate" {
    for_each = var.virtual_hubs.firewall_sku_tier == "Premium" && var.virtual_hubs.firewall_intrusion_detection_tls_certificate != null ? [var.virtual_hubs.firewall_intrusion_detection_tls_certificate] : []

    content {
      key_vault_secret_id = tls_certificate.value.key_vault_secret_id
      name                = tls_certificate.value.name
    }
  }

  dns {
    proxy_enabled = var.virtual_hubs.firewall_dns_proxy_enabled
    servers       = var.virtual_hubs.firewall_dns_servers
  }

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Firewall Policy"
    })
  )
}

resource "azurerm_virtual_hub_routing_intent" "this" {
  name           = var.virtual_hubs.routing_intent_name
  virtual_hub_id = azurerm_virtual_hub.this.id

  routing_policy {
    name         = "_policy_PublicTraffic"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.this.id
  }
  routing_policy {
    name         = "_policy_PrivateTraffic"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.this.id
  }
  depends_on = [azurerm_firewall.this, azurerm_firewall_policy.this]
}
