output "key_vault_ids" {
  value = {
    for key, kv in azurerm_key_vault.kv :
    key => kv.id
  }
}

output "secret_values" {
  value = {
    for key, secret in azurerm_key_vault_secret.secret :
    key => secret.value
  }

  sensitive = true
}