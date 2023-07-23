resource "azurerm_api_management" "apim" {
    name = var.apim_name
    resource_group_name = var.resource_group_name
    location = var.location
    publisher_name = var.publisher_name
    publisher_email = var.publisher_email
    sku_name = "${var.apim_sku_name}_${var.apim_sku_count}"
    public_ip_address_id = var.apim_public_ip_id
    virtual_network_type = var.vnet_integration_type
    virtual_network_configuration {
        subnet_id = var.apim_subnet_id
    }
    identity {
        type = "UserAssigned"
        identity_ids = [var.managed_identity_resoure_id]
    }
}

resource "azurerm_api_management_named_value" "fdid_nv" {
    name = local.FrontDoorHeaderIdValue
    resource_group_name = var.resource_group_name
    api_management_name = azurerm_api_management.apim.name
    display_name = local.FrontDoorHeaderIdValue
    secret = true # Must be set to true for a KV reference :(

    value_from_key_vault {
        secret_id = var.front_door_resource_guid_secret_uri
        identity_client_id = var.managed_identity_client_id
    }
}
