variable "virtual_machine" {
  type = map(object({
    vm_name               = string
    location              = string
    resource_group_name   = string
    virtual_network_name  = string
    subnet_name           = string
    nic_name              = string
    vm_size               = string

    admin_username = string
    admin_password = string
  }))

  sensitive = true
}