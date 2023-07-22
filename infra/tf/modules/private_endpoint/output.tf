output "private_endpoint_dns_name" {
    value = azurerm_private_dns_a_record.a_record.fqdn
}
