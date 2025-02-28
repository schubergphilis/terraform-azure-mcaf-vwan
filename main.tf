# This Terraform configuration defines resources and a module for deploying an Azure Virtual WAN setup.
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(var.tags, { "Resource Type" = "Resource Group" })
}

resource "azurerm_virtual_wan" "this" {
  resource_group_name               = var.resource_group_name
  location                          = var.location
  name                              = var.virtual_wan.name
  type                              = var.virtual_wan.type
  disable_vpn_encryption            = var.virtual_wan.disable_vpn_encryption
  allow_branch_to_branch_traffic    = var.virtual_wan.allow_branch_to_branch_traffic
  office365_local_breakout_category = var.virtual_wan.office365_local_breakout_category

  tags = merge(var.tags, { "Resource Type" = "Virtual WAN" })
}

module "vhub" {
  for_each = var.virtual_hubs

  source = "./modules/vhub"

  virtual_hubs        = each.value
  virtual_wan_id      = azurerm_virtual_wan.this.id
  resource_group_name = var.resource_group_name

  tags = var.tags
}
