# This Terraform configuration defines resources and a module for deploying an Azure Virtual WAN setup.
resource "azurerm_resource_group" "this" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Resource Group"
    })
  )
}

resource "azurerm_virtual_wan" "this" {
  name                = var.virtual_wan.name
  resource_group_name = azurerm_resource_group.this.name
  location            = coalesce(var.virtual_wan.location, azurerm_resource_group.this.location)
  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Virtual WAN"
    })
  )
}

module "vhub" {
  for_each            = var.virtual_hubs
  source              = "./modules/vhub"
  virtual_hubs        = var.virtual_hubs[each.key]
  virtual_wan_id      = azurerm_virtual_wan.this.id
  resource_group_name = azurerm_resource_group.this.name
  tags = merge(
    try(var.tags),
    tomap({
    })
  )
}

resource "azurerm_virtual_hub_bgp_connection" "this" {
  for_each = var.hub_bgp_peers != null ? var.hub_bgp_peers : {}
  virtual_hub_id                = each.value.virtual_hub_id
  name                          = each.value.name
  peer_asn                      = each.value.peer_asn
  peer_ip                       = each.value.peer_ip
  virtual_network_connection_id = each.value.vnet_connection_id
}