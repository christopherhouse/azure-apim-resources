provider "azurerm" {
    features {}
}

module "vnet" {
    source = "./modules/virtual_network"
    vnet_name = local.vnet_name
    address_space = var.vnet_address_space
    resource_group_name = var.resource_group_name
    location = var.location
    apim_subnet = var.apim_subnet_prefix
    key_vault_subnet = var.keyvault_subnet_prefix
    apim_nsg_name = local.apim_nsg_name
    https_to_vnet_nsg_name = local.https_to_vnet_nsg_name
    storage_subnet = var.storage_subnet_prefix
}

module "apim_pip" {
    source = "./modules/public_ip"
    public_ip_name = local.apim_public_ip_name
    resource_group_name = var.resource_group_name
    location = var.location
    dns_label = local.apim_name
}

module "apim_identity" {
    source = "./modules/user_assigned_managed_identity"
    identity_name = local.apim_identity_name
    resource_group_name = var.resource_group_name
    location = var.location
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
    managed_identity_resoure_id = module.apim_identity.id
}

module "storage" {
    source = "./modules/storage_account"
    storage_account_name = local.storage_account_name
    resource_group_name = var.resource_group_name
    location = var.location
    storage_sku = var.storage_sku
}

module "web_pe" {
    source = "./modules/private_endpoint"
    resource_group_name = var.resource_group_name
    location = var.location
    private_endpoint_name = local.web_private_endpoint_name
    vnet_id = module.vnet.id
    subnet_id = module.vnet.storage_subnet_id
    storage_account_name = local.storage_account_name
    storage_account_id = module.storage.id
}

module "afd" {
    source = "./modules/front_door"
    resource_group_name = var.resource_group_name
    location = var.location
    front_door_name = local.front_door_name
    apim_gateway_hostname = module.apim.apim_gateway_hostname
    primary_storage_web_hostname = module.storage.primary_web_hostname
    secondary_storage_web_hostname = module.storage.secondary_web_hostname
    storage_account_id = module.storage.id
    apim_mgmt_api_hostname = module.apim.apim_mgmt_api_hostname
}

module "key_vault" {
    source = "./modules/key_vault"
    key_vault_name = local.key_vault_name_short
    resource_group_name = var.resource_group_name
    location = var.location
    admin_object_id = var.admin_object_id
    apim_managed_identity_id = module.apim_identity.user_assigned_managed_identity_principal_id
    resource_name_prefix = var.resource_name_prefix
}
