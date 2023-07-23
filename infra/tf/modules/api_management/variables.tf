variable "apim_name" {
    type = string
    description = "Name of the API Management resource"
}

variable "resource_group_name" {
    type = string
    description = "Name of the resource group"
}

variable "location" {
    type = string
    description = "Azure region where the API Management resource should be created"
}

variable "publisher_name" {
    type = string
    description = "Name of the API publisher organization"
}

variable "publisher_email" {
    type = string
    description = "Email of the API publisher organization"
}

variable "apim_sku_name" {
    type = string
    description = "Name of the API Management SKU"

    validation {
        condition = contains(["Developer", "Basic", "Standard", "Premium", "Consumption"], var.apim_sku_name)
        error_message = "Invalid SKU name. Valid values are Developer, Basic, Standard, Premium, Consumption"
    }
}

variable "apim_sku_count" {
    type = number
    description = "Number of API Management scale units"
    default = 1

    validation {
        condition = var.apim_sku_count > 0 && var.apim_sku_count <= 12
        error_message = "Invalid SKU count. Valid values are between 1 and 12"
    }
}

variable "vnet_integration_type" {
    type = string
    description = "Type of VNet integration to use for the API Management service"

    validation {
        condition = contains(["None", "Internal", "External"], var.vnet_integration_type)
        error_message = "Invalid VNet integration type. Valid values are None, Internal, External"
    }
}

variable "apim_public_ip_id" {
    type = string
    description = "Resource id of the public ip address to use for the API Management service"
}

variable "apim_subnet_id" {
    type = string
    description = "Resource id of the subnet to use for the API Management service"
}

variable "managed_identity_resoure_id" {
    type = string
    description = "Resource id of the managed identity to use for the API Management service"
}

variable "managed_identity_client_id" {
    type = string
    description = "Client id of the managed identity to use for the API Management service"
}

variable "front_door_resource_guid_secret_uri" {
    type = string
    description = "Resource id of the front door to use for use in policy when validating requests come from front door"
    sensitive = true
}
