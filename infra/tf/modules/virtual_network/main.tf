resource "azurerm_network_security_group" "https_vnet_nsg" {
    name = var.https_to_vnet_nsg_name
    location = var.location
    resource_group_name = var.resource_group_name

    security_rule {
        name = "Allow_Https_To_Vnet"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        source_address_prefix = "VirtualNetwork"
        destination_port_range = "443"
        destination_address_prefix = "VirtualNetwork"
    }
}

resource "azurerm_network_security_group" "apim_nsg" {
    name = var.apim_nsg_name
    location = var.location
    resource_group_name = var.resource_group_name

    security_rule {
        name = "Allow_Mgmt_Traffic_To_Vnet"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "3443"
        source_address_prefix = "ApiManagement"
        destination_address_prefix = "VirtualNetwork"
    }

    security_rule {
        name = "Allow_Http_And_Https_To_Vnet"
        priority = 200
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_ranges  = [ "80", "443"]
        destination_port_range = "3443"
        source_address_prefix = "Internet"
        destination_address_prefix = "VirtualNetwork"
    }
}

resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    address_space       = [var.address_space]
    location            = var.location
    resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "apim_subnet" {
    name = "apim"
    address_prefixes = [var.apim_subnet]
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "keyvault_subnet" {
    name = "keyvault"
    address_prefixes = [var.key_vault_subnet]
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "storage_subnet" {
    name = "storage"
    address_prefixes = [var.storage_subnet]
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet_network_security_group_association" "apim_nsg_association" {
    subnet_id = azurerm_subnet.apim_subnet.id
    network_security_group_id = azurerm_network_security_group.apim_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "keyvault_nsg_association" {
    subnet_id = azurerm_subnet.keyvault_subnet.id
    network_security_group_id = azurerm_network_security_group.https_vnet_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "storage_nsg_association" {
    subnet_id = azurerm_subnet.storage_subnet.id
    network_security_group_id = azurerm_network_security_group.https_vnet_nsg.id
}
