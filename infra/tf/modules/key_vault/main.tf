data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
    name = var.key_vault_name
    resource_group_name = var.resource_group_name
    location = var.location
    tenant_id = data.azurerm_client_config.current.tenant_id
    soft_delete_retention_days = 30
    purge_protection_enabled = false

    sku_name = "standard"
    
    # TODO: Is the admin policy needed?  Probably not, but it's convenient for me, for now, remove later
    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = var.admin_object_id

        key_permissions = [
            "Backup", 
            "Create",
            "Decrypt",
            "Delete",
            "Encrypt",
            "Get",
            "Import",
            "List",
            "Purge",
            "Recover",
            "Restore",
            "Sign",
            "UnwrapKey",
            "Update",
            "Verify",
            "WrapKey",
            "Release",
            "Rotate",
            "GetRotationPolicy",
            "SetRotationPolicy"
            ]
        secret_permissions = [
            "Backup",
            "Delete",
            "Get",
            "List",
            "Purge",
            "Recover",
            "Restore",
            "Set"
            ]
        certificate_permissions = [
            "Backup",
            "Create",
            "Delete",
            "DeleteIssuers",
            "Get",
            "GetIssuers",
            "Import",
            "List",
            "ListIssuers",
            "ManageContacts",
            "ManageIssuers",
            "Purge",
            "Recover",
            "Restore",
            "SetIssuers",
            "Update"
            ]
    }

    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = var.apim_managed_identity_id

        secret_permissions = [
            "Get", "List"]
        certificate_permissions = ["Get", "List"]
    }

    network_acls {
        default_action = "Deny"
        virtual_network_subnet_ids = [var.key_vault_subnet_id]
        bypass = "None"
        ip_rules = [var.home_ip_address]
    }
}