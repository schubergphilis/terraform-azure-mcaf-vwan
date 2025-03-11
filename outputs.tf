output "resource_group_id" {
  description = "ID of the Resource Group created by the module"
  value       = azurerm_resource_group.this.id
}

output "virtual_hubs" {
  value = azurerm_virtual_wan.this.virtual_hubs
}

output "vpn_sites" {
  value = azurerm_virtual_wan.this.vpn_sites
}
