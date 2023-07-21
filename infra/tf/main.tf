provider "azurerm" {
    features {}
}
module "vnet" {
    source = "./modules/virtualNetwork"
    vnet_name = var.vnet_name
    address_space = var.address_space
    resource_group_name = var.resource_group_name
    apim_subnet = var.apim_subnet
    key_vault_subnet = var.key_vault_subnet
}