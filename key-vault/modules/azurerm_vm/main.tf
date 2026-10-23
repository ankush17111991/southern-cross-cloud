locals {
  vm_keys = nonsensitive(toset(keys(var.virtual_machine)))
}

data "azurerm_subnet" "subnets" {
  for_each = local.vm_keys

  name                 = var.virtual_machine[each.key].subnet_name
  virtual_network_name = var.virtual_machine[each.key].virtual_network_name
  resource_group_name  = var.virtual_machine[each.key].resource_group_name
}

resource "azurerm_network_interface" "nic" {
  for_each = local.vm_keys

  name                = var.virtual_machine[each.key].nic_name
  location            = var.virtual_machine[each.key].location
  resource_group_name = var.virtual_machine[each.key].resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnets[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = local.vm_keys

  name                = var.virtual_machine[each.key].vm_name
  resource_group_name = var.virtual_machine[each.key].resource_group_name
  location            = var.virtual_machine[each.key].location
  size                = var.virtual_machine[each.key].vm_size

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  admin_username = var.virtual_machine[each.key].admin_username
  admin_password = var.virtual_machine[each.key].admin_password

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}