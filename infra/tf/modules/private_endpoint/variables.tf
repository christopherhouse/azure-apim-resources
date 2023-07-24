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

variable "resource_id" {
    type = string
    description = "The resource id of the resource that the private endpoint will be attached to"
}

variable "resource_name" {
    type = string
    description = "The name of the resource that the private endpoint will be attached to"
}

variable "private_dns_zone_name" {
    type = string
    description = "The name of the private dns zone that will be created"
}

variable "subresource_name" {
    type = string
    description = "The name of the subresource for the private endpoint"
}
