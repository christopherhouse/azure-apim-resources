variable "public_ip_name" {
    type = string
    description = "Name of the public ip resource"
}

variable "resource_group_name" {
    type = string
    description = "Name of the resource group in which the public ip resource will be created"
}

variable "location" {
    type = string
    description = "Azure region in which the public ip resource will be created"
}

variable "dns_label" {
    type = string
    description = "DNS label for the public ip resource"
}