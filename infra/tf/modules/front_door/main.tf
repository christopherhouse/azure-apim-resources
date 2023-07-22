resource "azurerm_cdn_frontdoor_profile" "afd_profile" {
  name = var.front_door_name
  resource_group_name = var.resource_group_name
  sku_name = "Premium_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "gw_endpoint" {
    name = "apim-gw-endpoint"
    cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
}

resource "azurerm_cdn_frontdoor_endpoint" "portal_endpoint" {
    name = "apim-portal-endpoint"
    cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
}

resource "azurerm_cdn_frontdoor_endpoint" "mgmt_api_endpoint" {
    name = "apim-mgmt-api-endpoint"
    cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
}

resource "azurerm_cdn_frontdoor_origin_group" gw_origin_group {
    name = "apim-gw-origin-group"
    cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id

    load_balancing {
        sample_size = 4
        successful_samples_required = 3
    }

    health_probe {
        path = "/status-0123456789abcdef"
        request_type = "GET"
        protocol = "Https"
        interval_in_seconds = 120
    }
}

resource "azurerm_cdn_frontdoor_origin_group" portal_origin_group {
    name = "apim-portal-origin-group"
    cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id

    load_balancing {
        sample_size = 4
        successful_samples_required = 3
    }

    health_probe {
        path = "/"
        request_type = "GET"
        protocol = "Https"
        interval_in_seconds = 120
    }
}

resource "azurerm_cdn_frontdoor_origin_group" mgmt_api_origin_group {
    name = "apim-mgmt-api-origin-group"
    cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id

    load_balancing {
        sample_size = 4
        successful_samples_required = 3
    }
}

resource "azurerm_cdn_frontdoor_origin" "gw_origin" {
    name = "apim-gw-origin"
    cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.gw_origin_group.id
    enabled = true
    certificate_name_check_enabled  = false
    host_name = var.apim_gateway_hostname
    origin_host_header = var.apim_gateway_hostname
    http_port = 80
    https_port = 443
    weight = 1
    priority = 1
}

resource "azurerm_cdn_frontdoor_origin" "portal_origin" {
    name = "apim-portal-origin"
    cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.portal_origin_group.id
    enabled = true
    certificate_name_check_enabled  = true
    host_name = var.primary_storage_web_hostname
    origin_host_header = var.primary_storage_web_hostname
    http_port = 80
    https_port = 443

    private_link {
        request_message = "Please approve request to APIM developer portal"
        target_type = "web"
        location = var.location
        private_link_target_id = var.storage_account_id
    }
}

resource "azurerm_cdn_frontdoor_origin" "portal_secondary_origin" {
    name = "apim-portal-secondary-origin"
    cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.portal_origin_group.id
    enabled = true
    certificate_name_check_enabled  = true
    host_name = var.secondary_storage_web_hostname
    origin_host_header = var.secondary_storage_web_hostname
    http_port = 80
    https_port = 443

    private_link {
        request_message = "Please approve request to APIM developer portal"
        target_type = "web"
        location = var.location
        private_link_target_id = var.storage_account_id
    }
}

resource "azurerm_cdn_frontdoor_origin" "mgmt_api_origin" {
    name = "apim-mgmt-api-origin"
    cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.mgmt_api_origin_group.id
    enabled = true
    certificate_name_check_enabled  = false
    host_name = var.apim_mgmt_api_hostname
    origin_host_header = var.apim_mgmt_api_hostname
    http_port = 80
    https_port = 443
    weight = 1
    priority = 1
}

resource "azurerm_cdn_frontdoor_route" "gw_route" {
    name = "apim-gw-route"
    cdn_frontdoor_endpoint_id = azurerm_cdn_frontdoor_endpoint.gw_endpoint.id
    cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.gw_origin_group.id
    cdn_frontdoor_origin_ids = [azurerm_cdn_frontdoor_origin.gw_origin.id]
    
    supported_protocols = ["Https", "Http"]
    patterns_to_match = ["/*"]
    forwarding_protocol = "HttpsOnly"
    link_to_default_domain = true
    https_redirect_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "portal_route" {
    name = "apim-gw-route"
    cdn_frontdoor_endpoint_id = azurerm_cdn_frontdoor_endpoint.portal_endpoint.id
    cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.portal_origin_group.id
    cdn_frontdoor_origin_ids = [azurerm_cdn_frontdoor_origin.portal_origin.id, azurerm_cdn_frontdoor_origin.portal_secondary_origin.id]
    
    supported_protocols = ["Https", "Http"]
    patterns_to_match = ["/*"]
    forwarding_protocol = "HttpsOnly"
    link_to_default_domain = true
    https_redirect_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "mgmt_api_route" {
    name = "apim-gw-route"
    cdn_frontdoor_endpoint_id = azurerm_cdn_frontdoor_endpoint.mgmt_api_endpoint.id
    cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.mgmt_api_origin_group.id
    cdn_frontdoor_origin_ids = [azurerm_cdn_frontdoor_origin.mgmt_api_origin.id]
    
    supported_protocols = ["Https", "Http"]
    patterns_to_match = ["/*"]
    forwarding_protocol = "HttpsOnly"
    link_to_default_domain = true
    https_redirect_enabled = true
}
