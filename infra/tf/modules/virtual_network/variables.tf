variable "vnet_name" {
    type = string
    description = "Name of the virtual network"
}

variable "resource_group_name" {
    type = string
    description = "Name of the resource group"
}

variable "location" {
    type = string
    description = "Location of the resource virtual network to be created"
}

variable "address_space" {
    type = string
    description = "Address space of the virtual network"
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

variable "observability_subnet" {
    type = string
    description = "Observability subnet cidr block"
}

variable "app_subnet" {
    type = string
    description = "App subnet cidr block"
}

variable "apim_nsg_name" {
    type = string
    description = "APIM NSG name"
}

variable "https_to_vnet_nsg_name" {
    type = string
    description = "NSG name for allowing https traffic from vnet"
}