provider "azurerm" {
    features {}
}

locals {
    vnet_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-vnet"
    apim_nsg_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim-nsg"
    storage_nsg_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-storage-nsg"
    keyvault_nsg_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-keyvault-nsg"
    apim_public_ip_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim-pip"
    apim_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim"
    storage_account_name = "${replace(var.resource_name_prefix, "-", "")}${replace(var.resource_name_base_name, "-", "")}${var.environment_name}sa"
}

module "vnet" {
    source = "./modules/virtual_network"
    vnet_name = local.vnet_name
    address_space = var.vnet_address_space
    resource_group_name = var.resource_group_name
    apim_subnet = var.apim_subnet_prefix
    key_vault_subnet = var.keyvault_subnet_prefix
    apim_nsg_name = local.apim_nsg_name
    keyvault_nsg_name = local.keyvault_nsg_name
    storage_nsg_name = local.storage_nsg_name
}

module "apim_pip" {
    source = "./modules/public_ip"
    public_ip_name = local.apim_public_ip_name
    resource_group_name = var.resource_group_name
    location = var.location
    dns_label = local.apim_name
}

module "apim" {
    source = "./modules/api_management"
    apim_name = local.apim_name
    resource_group_name = var.resource_group_name
    location = var.location
    publisher_name = var.apim_publisher_name
    publisher_email = var.apim_publisher_email
    apim_sku_name = var.apim_sku_name
    apim_sku_count = var.apim_sku_capacity
    vnet_integration_type  = var.apim_vnet_integration_type
    apim_public_ip_id = module.apim_pip.id
    apim_subnet_id = module.vnet.apim_subnet_id
}

module "storage" {
    source = "./modules/storage_account"
    storage_account_name = local.storage_account_name
    resource_group_name = var.resource_group_name
    location = var.location
    storage_sku = var.storage_sku
}
