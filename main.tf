resource "azurerm_resource_group" "this" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

resource "azurerm_virtual_wan" "this" {
  name                = var.virtual_wan.name
  resource_group_name = azurerm_resource_group.this.name
  location            = coalesce(var.virtual_wan.location, azurerm_resource_group.this.location)
}

module "vhub" {
  for_each            = var.virtual_hubs
  source              = "./modules/vhub"
  virtual_hubs        = var.virtual_hubs[each.key]
  virtual_wan_id      = azurerm_virtual_wan.this.id
  resource_group_name = azurerm_resource_group.this.name
}