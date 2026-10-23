variable "key_vaults" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
}

variable "secrets" {
  type = map(object({
    name          = string
    value         = string
    key_vault_key = string
  }))

  sensitive = true
}