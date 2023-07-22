resource "azurerm_private_dns_zone" "dns_zone" {
    name = "privatelink.web.core.windows.net"
    resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
    name = "vnet_link"
    resource_group_name = var.resource_group_name
    private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
    virtual_network_id = var.vnet_id
}

resource "azurerm_private_endpoint" "pe" {
    name = var.private_endpoint_name
    resource_group_name = var.resource_group_name
    location = var.location
    subnet_id = var.subnet_id

    private_service_connection {
        name = "${var.private_endpoint_name}-connection"
        private_connection_resource_id = var.storage_account_id
        is_manual_connection = false
        subresource_names = ["web"]
    }
}

resource "azurerm_private_dns_a_record" "a_record" {
    name = var.storage_account_name
    zone_name = azurerm_private_dns_zone.dns_zone.name
    resource_group_name = var.resource_group_name
    ttl = 300
    records = [azurerm_private_endpoint.pe.private_service_connection.0.private_ip_address]
}
