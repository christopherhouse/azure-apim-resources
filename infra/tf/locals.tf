resource "random_id" "rid" {
    byte_length = 2

    keepers = {
        resource_name_prefix = var.resource_name_prefix
    }
}

locals {
    vnet_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-vnet"
    apim_nsg_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim-nsg"
    apim_public_ip_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim-pip"
    apim_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim"
    storage_account_name = "${replace(var.resource_name_prefix, "-", "")}${replace(var.resource_name_base_name, "-", "")}${var.environment_name}sa"
    https_to_vnet_nsg_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-https-to-vnet-nsg"
    web_private_endpoint_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-web-pe"
    front_door_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-afd"
    apim_identity_name = "${var.resource_name_prefix}-${var.resource_name_base_name}-${var.environment_name}-apim-umi"
    key_vault_name = "${var.resource_name_prefix}${var.resource_name_base_name}${var.environment_name}kv"
    key_vault_name_short = "${substr(local.key_vault_name, 0, 19)}-${random_id.rid.hex}"
    kv_private_endpoint_name = "${local.key_vault_name}-pe"
    front_door_id_secret_name = "X-Azure-FDID"
    storage_web_private_dns_zone = "privatelink.web.core.windows.net"
    key_vault_private_dns_zone = "privatelink.vaultcore.azure.net"
}
