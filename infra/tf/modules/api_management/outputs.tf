output "apim_gateway_hostname" {
    value = replace(replace(azurerm_api_management.apim.gateway_url, "https://", ""), "/", "")
}

output "apim_mgmt_api_hostname" {
    value = replace(replace(azurerm_api_management.apim.management_api_url, "https://", ""), "/", "")
}
