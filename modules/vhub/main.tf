
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
    public_ip_count = var.virtual_hubs.firewall_public_ip_count
  }

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Firewall"
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
      mode = var.virtual_hubs.firewall_intrusion_detection_mode
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
