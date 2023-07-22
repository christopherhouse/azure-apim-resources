variable "vnet_name" {
    type = string
    description = "Name of the virtual network"
}

variable "address_space" {
    type = string
    description = "Address space of the virtual network"
}

variable "resource_group_name" {
    type = string
    description = "Name of the resource group"
}

variable "apim_subnet" {
    type = string
    description = "APIM subnet cidr block"
}

variable "key_vault_subnet" {
    type = string
    description = "Key Vault subnet cidr block"
}

variable "storage_subnet" {
    type = string
    description = "Storage subnet cidr block"
}

variable "apim_nsg_name" {
    type = string
    description = "APIM NSG name"
}

variable keyvault_nsg_name {
    type = string
    description = "Key Vault NSG name"
}

variable storage_nsg_name {
    type = string
    description = "Storage NSG name"
}