variable "key_vault_name" {
    type = string
    description = "Name of the key vault to be created"
}

variable "resource_group_name" {
    type = string
    description = "Name of the resource group the Key Vault will be created in"
}

variable "location" {
    type = string
    description = "The Azure region where the Key Vault will be created"
}

variable "admin_object_id" {
    type = string
    description = "The object ID of the user or service principal that will be granted admin access to the Key Vault"
}

variable "apim_managed_identity_id" {
    type = string
    description = "The client id of the APIM managed identity that will be granted access to the Key Vault"
}

variable "resource_name_prefix" {
    type = string
    description = "Prefix to be used for naming resources, used in this module as a keeper for a random id that is part of the Key Vault resource name"
}

variable "key_vault_subnet_id" {
    type = string
    description = "The resource id of the subnet where the Key Vault will be attached"
}

variable "home_ip_address" {
    type = string
    description = "The public IP address of the machine from which the Key Vault will be accessed"
}
