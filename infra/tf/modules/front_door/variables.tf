variable "front_door_name" {
    type = string
    description = "Name of the Azure Front Door resource to create"
}

variable "resource_group_name" {
    type = string
    description = "Name of the Azure Resource Group that the Front Door resources will be created in"
}

variable "location" {
    type = string
    description = "Location that the Front Door resources will be created in"
}

variable "apim_gateway_hostname" {
    type = string
    description = "Hostname for APIM's gateway endpoint" 
}

variable "apim_mgmt_api_hostname" {
    type = string
    description = "Hostname for APIM's management API endpoint" 
}

variable "primary_storage_web_hostname" {
    type = string
    description = "Hostname for the storage account's primary web endpoint"
}

variable "secondary_storage_web_hostname" {
    type = string
    description = "Hostname for the storage account's secondary web endpoint"
}

variable "storage_account_id" {
    type = string
    description = "Resource id of the storage account used for static web content"
}
