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
}