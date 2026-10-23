terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>5.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "prabhat-rg"
  #   storage_account_name = "prabhattestingsg12"
  #   container_name       = "tfstate"
  #   key                  = "practice.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}