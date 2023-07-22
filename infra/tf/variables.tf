variable "resource_group_name" {
    type = string
}

variable "resource_name_prefix" {
    type = string
}

variable "resource_name_base_name" {
    type = string
}

variable "environment_name" {
    type = string
}

variable "location" {
    type = string
}

variable "virtual_network_type" {
    type = string
    description = "APIM virtual network integration type"

    validation {
        condition = contains(["Internal", "External", "None"], var.virtual_network_type)
        error_message = "Invalid virtual network type, must be Internal, External or None"  
    }
}

variable "vnet_address_space" {
    type = string
}

variable "apim_subnet_prefix" {
    type = string
    description = "APIM subnet cidr block"
}

variable keyvault_subnet_prefix {
    type = string
    description = "Key Vault subnet cidr block"
}

variable "storage_subnet_prefix" {
    type = string
    description = "Storage subnet cidr block"
}

variable "apim_publisher_email" {
    type = string
}

variable "apim_publisher_name" {
    type = string
}

variable "apim_sku_capacity" {
    type = number
}

variable "apim_sku_name" {
    type = string
    description = "APIM SKU name"

    validation {
        condition = contains(["Developer", "Basic", "Standard", "Premium", "Consumption"], var.apim_sku_name)
        error_message = "Invalid SKU name, must be Developer, Basic, Standard, Premium or Consumption"  
    }
}

variable "apim_vnet_integration_type" {
    type = string
    description = "APIM virtual network integration type"

    validation {
        condition = contains(["Internal", "External", "None"], var.apim_vnet_integration_type)
        error_message = "Invalid virtual network type, must be Internal, External or None"  
    }
}

variable "deploy_waf_solution" {
    type = bool
    description = "Deploy WAF solution"

    default = false
}

variable "storage_sku" {
  type = string
  description = "Sku of the storage account"
  default = "GRS"

  validation {
        condition = contains(["LRS", "GRS", "RAGRS", "ZRS"], var.storage_sku)
        error_message = "Invalid storage SKU"
    }
}
