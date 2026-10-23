data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each = var.key_vaults

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"

  rbac_authorization_enabled = true 

  soft_delete_retention_days = 7
  purge_protection_enabled   = true

}

resource "azurerm_key_vault_secret" "secret" {
  depends_on = [azurerm_role_assignment.secret_officer]

  for_each = nonsensitive(toset(keys(var.secrets)))

  name         = var.secrets[each.key].name
  value        = var.secrets[each.key].value
  key_vault_id = azurerm_key_vault.kv[var.secrets[each.key].key_vault_key].id
}

resource "azurerm_role_assignment" "secret_officer" {
  for_each = azurerm_key_vault.kv

  scope                = each.value.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}