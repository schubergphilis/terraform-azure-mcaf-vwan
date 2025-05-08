terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx"
}

resource "azurerm_resource_group" "this" {
  name     = "example-resource-group"
  location = "eastus"
  tags = {
    "Environment"   = "Production"
    "Resource Type" = "Resource Group"
  }
}

resource "azurerm_virtual_wan" "this" {
  name                = "example-virtual-wan"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags = {
    "Environment"   = "Production"
    "Resource Type" = "Virtual WAN"
  }
}

module "vhub" {
  source = "../modules/vhub"

  for_each = {
    hub1 = {
      virtual_hub_name                            = "example-virtual-hub"
      location                                    = "eastus"
      address_prefix                              = "10.0.0.0/16"
      routing_intent_name                         = "example-routing-intent"
      firewall_name                               = "example-firewall"
      firewall_zones                              = ["1", "2", "3"]
      firewall_policy_name                        = "example-firewall-policy"
      firewall_sku_tier                           = "Premium"
      firewall_public_ip_prefix_length            = 30
      firewall_threat_intelligence_mode           = "Alert"
      firewall_dns_proxy_enabled                  = true
      firewall_dns_servers                        = ["8.8.8.8", "8.8.4.4"]
      firewall_deploy                             = true
      firewall_classic_ip_config                  = false
      firewall_intrusion_detection_mode           = "Deny"
      firewall_intrusion_detection_private_ranges = ["10.0.0.0/28"]
      firewall_intrusion_detection_signature_overrides = [
        {
          id    = "2024898"
          state = "Alert"
        }
      ]
      firewall_intrusion_detection_traffic_bypass = [
        {
          name                  = "SecretBypass"
          protocol              = "TCP"
          description           = "SecretBypass"
          source_addresses      = ["*"]
          destination_addresses = ["*"]
          destination_ports     = ["443"]
      }]
      firewall_intrusion_detection_tls_certificate = {
        key_vault_secret_id = "/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx/resourceGroups/example-resource-group/providers/Microsoft.KeyVault/vaults/example-kv"
        name                = "certname"
      }
      hub_bgp_peers = {
        peer1 = {
          virtual_hub_id     = "example-virtual-hub-id"
          name               = "example-peer"
          peer_asn           = 65001
          peer_ip            = "10.0.1.1"
          vnet_connection_id = "example-vnet-id"
        }
      }
    }
  }
  virtual_hubs        = each.value
  virtual_wan_id      = azurerm_virtual_wan.this.id
  resource_group_name = azurerm_resource_group.this.name
  tags = {
    "Environment"   = "Production"
    "Resource Type" = "Virtual Hub"
  }
}

resource "azurerm_virtual_hub_bgp_connection" "this" {
  for_each = {
    peer1 = {
      virtual_hub_id     = "example-virtual-hub-id"
      name               = "example-peer"
      peer_asn           = 65001
      peer_ip            = "10.0.1.1"
      vnet_connection_id = "example-vnet-id"
    }
  }
  virtual_hub_id                = each.value.virtual_hub_id
  name                          = each.value.name
  peer_asn                      = each.value.peer_asn
  peer_ip                       = each.value.peer_ip
  virtual_network_connection_id = each.value.vnet_connection_id
}
