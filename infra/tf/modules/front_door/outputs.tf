output "front_door_resource_guid" {
    value = sensitive(azurerm_cdn_frontdoor_profile.afd_profile.resource_guid)
}
