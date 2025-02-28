terraform {
  required_version = ">= 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4"
    }
  }
}
resource "azurerm_resource_group" "this" {
  name     = "example-rg"
  location = "eastus"
  tags = {
    "Environment"   = "Production"
    "Resource Type" = "Resource Group"
  }
}

module "vwan" {
  source = "../.."

  resource_group_name = azurerm_resource_group.this.name

  virtual_wan = {
    name = "example-vwan"
  }

  virtual_hubs = {

    hub1 = {
      virtual_hub_name     = "example-virtual-hub"
      location             = "eastus"
      address_prefix       = "10.0.0.0/16"
      virtual_wan_id       = "id"
      routing_intent_name  = "example-routing-intent"
      firewall_name        = "example-firewall"
      firewall_policy_name = "example-firewall-policy"

      hub_bgp_peers = {
        peer1 = {
          name               = "example-peer"
          peer_asn           = 65001
          peer_ip            = "10.0.1.1"
          vnet_connection_id = "example-vnet-id"
        }
      }
    }
  }
  tags = {
    Environment = "Production"
  }
}