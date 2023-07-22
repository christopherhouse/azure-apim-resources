locals {
    vnet_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-vnet"
    apim_nsg_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim-nsg"
    apim_public_ip_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim-pip"
    apim_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim"
    storage_account_name = "${replace(var.resource_name_prefix, "-", "")}${replace(var.resource_name_base_name, "-", "")}${var.environment_name}sa"
    https_to_vnet_nsg_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-https-to-vnet-nsg"
    web_private_endpoint_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-web-pe"
}
