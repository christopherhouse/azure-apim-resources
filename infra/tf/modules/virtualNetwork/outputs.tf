output "id" {
    value = azurerm_virtual_network.vnet.id
}

output apim_subnet_id {
    value = azurerm_subnet.apim_subnet.id
}

output keyvault_subnet_id {
    value = azurerm_subnet.keyvault_subnet.id
}

#TODO: output subnet ids as discrete properties