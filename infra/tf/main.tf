provider "azurerm" {
    features {}
}

locals {
    vnet_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-vnet"
    apim_nsg_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim-nsg"
    keyvault_nsg_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-keyvault-nsg"
    apim_public_ip_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim-pip"
    apim_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim"
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
}

module "apim_pip" {
    source = "./modules/public_ip"
    public_ip_name = local.apim_public_ip_name
    resource_group_name = var.resource_group_name
    location = var.location
    dns_label = local.apim_name
}
