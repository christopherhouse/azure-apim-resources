locals {
    vnet_link_name = "vnet_link_${replace(var.private_dns_zone_name, ".", "_")}"
}
