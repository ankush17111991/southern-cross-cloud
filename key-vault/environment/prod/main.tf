module "resource_group" {

  source = "../../modules/azurerm_rg"

  rg = {
    prod = {
      name     = "prod-rg"
      location = "central us"
    }
    prod1 = {
      name     = "prod-rg1"
      location = "central us"
    }
  }
}

module "vnet" {

  source     = "../../modules/azurerm_vnet"
  depends_on = [module.resource_group]
  vnet = {
    prod = {
      name                = "prod-vnet"
      location            = "central us"
      resource_group_name = "prod-rg"
      address_space       = ["10.0.0.0/16"]
    }
  }
}

module "subnet" {
  source     = "../../modules/azurerm_subnet"
  depends_on = [module.vnet]
  subnets = {
    subnet1 = {
      name                 = "prod-subnet"
      resource_group_name  = "prod-rg"
      virtual_network_name = "prod-vnet"
      address_prefixes     = ["10.0.1.0/24"]
    }

    bastion_subnet = {
      name                 = "AzureBastionSubnet"
      resource_group_name  = "prod-rg"
      virtual_network_name = "prod-vnet"
      address_prefixes     = ["10.0.2.0/26"]
    }
  }
}

module "bastion" {

  source = "../../modules/azurerm_bastion"
  bastion = {
    prod = {
      bastion_name         = "prod-bastion"
      location             = "central us"
      resource_group_name  = "prod-rg"
      subnet_name          = "AzureBastionSubnet"
      virtual_network_name = "prod-vnet"
      public_ip_name       = "prod-bastion-pip"
    }
  }

  depends_on = [module.subnet]
}


module "virtual_machine" {

  source = "../../modules/azurerm_vm"

  depends_on = [
    module.subnet,
    module.key_vault
  ]

  virtual_machine = {
    prod = {
      vm_name              = "prod-vm"
      location             = "centralus"
      resource_group_name  = "prod-rg"
      virtual_network_name = "prod-vnet"
      subnet_name          = "prod-subnet"
      nic_name             = "prod-nic"
      vm_size              = "Standard_D2alds_v7"

      admin_username = module.key_vault.secret_values["vm_username"]
      admin_password = module.key_vault.secret_values["vm_password"]
    }
  }
}

module "key_vault" {
  source = "../../modules/azurerm_kv"

  depends_on = [module.resource_group]

  key_vaults = {
    prod = {
      name                = "prod-kv-1711"
      location            = "centralus"
      resource_group_name = "prod-rg"
    }
  }

  secrets = {
    vm_username = {
      name          = "vm-username"
      value         = "adminuser"
      key_vault_key = "prod"
    }

    vm_password = {
      name          = "vm-password"
      value         = "Admin@123"
      key_vault_key = "prod"
    }
  }
}