
resource "azurerm_virtual_hub" "this" {
  name                = var.virtual_hubs.name
  resource_group_name = var.resource_group_name
  location            = var.virtual_hubs.location
  address_prefix      = var.virtual_hubs.address_prefix
  virtual_wan_id      = var.virtual_wan_id
}

resource "azurerm_virtual_hub_routing_intent" "this" {
  name           = "${var.virtual_hubs.name}-routing-intent"
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
}

resource "azurerm_firewall" "this" {
  name                = "${var.virtual_hubs.name}-firewall"
  resource_group_name = var.resource_group_name
  location            = var.virtual_hubs.location
  sku_name            = "AZFW_Hub"
  sku_tier            = var.virtual_hubs.firewall_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.this.id
  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.this.id
    public_ip_count = var.virtual_hubs.firewall_public_ip_count
  }
}

resource "azurerm_firewall_policy" "this" {
  name                = "${var.virtual_hubs.name}-firewall-policy"
  resource_group_name = var.resource_group_name
  location            = var.virtual_hubs.location
  sku                 = var.virtual_hubs.firewall_sku_tier
  threat_intelligence_mode = var.virtual_hubs.firewall_threat_intelligence_mode
  dns {
    proxy_enabled = var.virtual_hubs.firewall_proxy_enabled
    servers       = var.virtual_hubs.firewall_dns_servers
  }
}

