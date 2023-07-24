resource "azurerm_monitor_private_link_scope" "ampls" {
    name = var.private_link_scope_name
    resource_group_name = var.resource_group_name
}

resource "azurerm_log_analytics_workspace" "laws" {
    name = var.log_analytics_workspace_name
    resource_group_name = var.resource_group_name
    location = var.location
    sku = "PerGB2018"
    retention_in_days = var.log_retention_days
    internet_ingestion_enabled = false
    internet_query_enabled = true # disable for real scenaroes.  Leaving it on here to avoid need for a jumpbox.
}

resource "azurerm_application_insights" "ai" {
    name = var.app_insights_name
    location = var.location
    resource_group_name = var.resource_group_name
    workspace_id = azurerm_log_analytics_workspace.laws.id
    application_type = "web"
    retention_in_days = var.log_retention_days
    internet_ingestion_enabled = false
    internet_query_enabled = true
}

resource "azurerm_monitor_private_link_scoped_service" "laws_svc" {
    name = var.log_analytics_workspace_name
    resource_group_name = var.resource_group_name
    scope_name = azurerm_monitor_private_link_scope.ampls.name
    linked_resource_id = azurerm_log_analytics_workspace.laws.id
}

resource "azurerm_monitor_private_link_scoped_service" "ai_svc" {
    name = var.app_insights_name
    resource_group_name = var.resource_group_name
    scope_name = azurerm_monitor_private_link_scope.ampls.name
    linked_resource_id = azurerm_application_insights.ai.id
}

resource "azurerm_private_dns_zone" "zone" {
    for_each = local.private_dns_zone_names
    name = each.value
    resource_group_name = var.resource_group_name
}

resource "azurerm_private_endpoint" "pe" {
    name = var.private_endpoint_name
    location = var.location
    resource_group_name = var.resource_group_name
    subnet_id = var.observability_subnet_id

    private_dns_zone_group {
        name = "default"
        private_dns_zone_ids = [for _, v in azurerm_private_dns_zone.zone : v.id]
    }

    private_service_connection {
        name = var.private_endpoint_name
        is_manual_connection = false
        private_connection_resource_id = azurerm_monitor_private_link_scope.ampls.id
        subresource_names = ["azuremonitor"]
    }
}
