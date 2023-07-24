output "id" {
    value = azurerm_virtual_network.vnet.id
}

output "apim_subnet_id" {
    value = azurerm_subnet.apim_subnet.id
}

output "key_vault_subnet_id" {
    value = azurerm_subnet.keyvault_subnet.id
}

output "storage_subnet_id" {
    value = azurerm_subnet.storage_subnet.id
}

output "observability_subnet_id" {
    value = azurerm_subnet.observability_subnet.id
}

output "app_subnet_id" {
    value = azurerm_subnet.app_subnet.id
}