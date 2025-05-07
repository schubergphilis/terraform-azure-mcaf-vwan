locals {
  firewall_id = var.firewall_deploy ? (
    var.firewall_classic_ip_config ? azurerm_firewall.this[0].id : azapi_resource.firewall[0].id
  ) : null

  firewall_public_ip_addresses = var.firewall_deploy ? (
    var.firewall_classic_ip_config ? (
      try(azurerm_firewall.this[0].virtual_hub[0].public_ip_addresses, [])
      ) : (
      [try(azurerm_public_ip.this[0].ip_address, null)]
    )
  ) : []
}