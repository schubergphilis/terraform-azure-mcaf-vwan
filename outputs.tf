output "resource_group_id" {
  description = "ID of the Resource Group created by the module"
  value       = azurerm_resource_group.this.id
}