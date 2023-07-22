variable "resource_group_name" {
    type = string
    description = "The name of the resource group in which to create the private endpoint"
}

variable "location" {
    type = string
    description = "The location where the private endpoint will be created"
}

variable "private_endpoint_name" {
    type = string
    description = "The name of the private endpoint"
}

variable "vnet_id" {
    type = string
    description = "The resource id of the virtual network that the private endpoint will be attached to"
}

variable "subnet_id" {
    type = string
    description = "The resource id of the subnet that the private endpoint will be attached to"
}

variable "storage_account_id" {
    type = string
    description = "The resource id of the storage account that the private endpoint will be attached to"
}

variable "storage_account_name" {
    type = string
    description = "The name of the storage account that the private endpoint will be attached to"
}