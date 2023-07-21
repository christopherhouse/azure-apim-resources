data "azurerm_resource_group" "rg" {
    name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    address_space       = [var.address_space]
    location            = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "apim_subnet" {
    name = "apim"
    address_prefixes = [var.apim_subnet]
    resource_group_name = data.azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "keyvault_subnet" {
    name = "keyvault"
    address_prefixes = [var.key_vault_subnet]
    resource_group_name = data.azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
}