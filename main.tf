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
  resource_group_name               = azurerm_resource_group.this.name
  location                          = coalesce(var.virtual_wan.location, azurerm_resource_group.this.location)
  name                              = var.virtual_wan.name
  type                              = var.virtual_wan.type
  disable_vpn_encryption            = var.virtual_wan.disable_vpn_encryption
  allow_branch_to_branch_traffic    = var.virtual_wan.allow_branch_to_branch_traffic
  office365_local_breakout_category = var.virtual_wan.office365_local_breakout_category

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Virtual WAN"
    })
  )
}

module "vhub" {
  for_each = var.virtual_hubs

  source = "./modules/vhub"

  virtual_hubs        = var.virtual_hubs[each.key]
  virtual_wan_id      = azurerm_virtual_wan.this.id
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_virtual_hub_bgp_connection" "this" {
  for_each = var.hub_bgp_peers

  virtual_hub_id                = each.value.virtual_hub_id
  name                          = each.value.name
  peer_asn                      = each.value.peer_asn
  peer_ip                       = each.value.peer_ip
  virtual_network_connection_id = each.value.vnet_connection_id
}
