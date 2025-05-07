# This Terraform configuration defines resources for an Azure Virtual Hub setup, including:
# - azurerm_virtual_hub: Represents a Virtual Hub in Azure Virtual WAN.
# - azurerm_virtual_hub_routing_intent: Defines routing policies for the Virtual Hub.
# - azurerm_firewall: Configures an Azure Firewall associated with the Virtual Hub.
# - azurerm_firewall_policy: Specifies the Firewall Policy for the Azure Firewall.
data "azurerm_client_config" "current" {}

resource "azurerm_virtual_hub" "this" {
  name                = var.virtual_hub_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_prefix      = var.address_prefix
  virtual_wan_id      = var.virtual_wan_id

  tags = merge(var.tags, { "Resource Type" = "Virtual Hub" })
}

resource "azurerm_firewall" "this" {
  count = var.firewall_deploy && var.firewall_classic_ip_config ? 1 : 0

  name                = var.firewall_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "AZFW_Hub"
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.this[0].id
  zones               = var.firewall_zones



  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.this.id
    public_ip_count = var.firewall_public_ip_count
  }

  tags = merge(var.tags, { "Resource Type" = "Firewall" })
}

resource "azurerm_public_ip" "this" {
  count = var.firewall_deploy && !var.firewall_classic_ip_config ? 1 : 0

  name                = "${var.firewall_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.firewall_zones

  tags = merge(var.tags, { "Resource Type" = "Public IP" })
}

resource "azapi_resource" "firewall" {
  count = var.firewall_deploy && !var.firewall_classic_ip_config ? 1 : 0

  type     = "Microsoft.Network/azureFirewalls@2024-05-01"
  name     = var.firewall_name
  location = var.location
  tags     = merge(var.tags, { "Resource Type" = "Firewall" })

  body = {
    properties = {
      virtualHub = {
        id = azurerm_virtual_hub.this.id
      }
      sku = {
        name = "AZFW_Hub"
        tier = var.firewall_sku_tier
      }
      ipConfigurations = [
        {
          name = "${var.firewall_name}-pip1"
          properties = {
            publicIPAddress = {
              id = azurerm_public_ip.this[0].id
            }
          }
        }
      ]
      firewallPolicy = {
        id = azurerm_firewall_policy.this[0].id
      }
    }
    zones = var.firewall_zones
  }

  schema_validation_enabled = false
  parent_id                 = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"

  depends_on = [azurerm_virtual_hub.this, azurerm_public_ip.this]
}

resource "azurerm_firewall_policy" "this" {
  count = var.firewall_deploy ? 1 : 0

  name                     = var.firewall_policy_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.firewall_sku_tier
  threat_intelligence_mode = var.firewall_threat_intelligence_mode

  dynamic "intrusion_detection" {
    for_each = var.firewall_sku_tier == "Premium" ? [1] : []

    content {
      mode           = var.firewall_intrusion_detection_mode
      private_ranges = try(var.firewall_intrusion_detection_private_ranges, [])

      dynamic "signature_overrides" {
        for_each = try(var.firewall_intrusion_detection_signature_overrides, [])
        content {
          id    = signature_overrides.value.id
          state = signature_overrides.value.state
        }
      }

      dynamic "traffic_bypass" {
        for_each = try(var.firewall_intrusion_detection_traffic_bypass, [])

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
    for_each = var.firewall_sku_tier == "Premium" && var.firewall_intrusion_detection_tls_certificate != null ? [var.firewall_intrusion_detection_tls_certificate] : []

    content {
      key_vault_secret_id = tls_certificate.value.key_vault_secret_id
      name                = tls_certificate.value.name
    }
  }

  dns {
    proxy_enabled = var.firewall_dns_proxy_enabled
    servers       = var.firewall_dns_servers
  }

  tags = merge(var.tags, { "Resource Type" = "Firewall Policy" })
}

resource "azurerm_virtual_hub_routing_intent" "this" {
  count = var.firewall_deploy ? 1 : 0

  name           = var.routing_intent_name
  virtual_hub_id = azurerm_virtual_hub.this.id

  routing_policy {
    name         = "_policy_PublicTraffic"
    destinations = ["Internet"]
    next_hop     = local.firewall_id
  }
  routing_policy {
    name         = "_policy_PrivateTraffic"
    destinations = ["PrivateTraffic"]
    next_hop     = local.firewall_id
  }
  depends_on = [azurerm_firewall_policy.this, azapi_resource.firewall, azurerm_firewall.this]
}
