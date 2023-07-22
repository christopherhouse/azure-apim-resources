output "id" {
    value = azurerm_virtual_network.vnet.id
}

output apim_subnet_id {
    value = azurerm_subnet.apim_subnet.id
}

output keyvault_subnet_id {
    value = azurerm_subnet.keyvault_subnet.id
}

output storage_subnet_id {
    value = azurerm_subnet.storage_subnet.id
}