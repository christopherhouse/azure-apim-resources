resource "azurerm_public_ip" "apim_pip" {
    name = var.public_ip_name
    resource_group_name = var.resource_group_name
    location = var.location
    allocation_method = "Static"
    domain_name_label = var.dns_label
}