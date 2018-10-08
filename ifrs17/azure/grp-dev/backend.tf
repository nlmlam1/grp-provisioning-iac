terraform {
  backend "azurerm" {
    resource_group_name  = "poc-ukwest-main-rg"
    storage_account_name = "atradius"
    container_name       = "poc-ukwest-sc"
    key                  = "grp"
  }
}

data "terraform_remote_state" "base" {
  backend = "azurerm"

  config {
    resource_group_name  = "poc-ukwest-main-rg"
    storage_account_name = "atradius"
    container_name       = "poc-ukwest-sc"
    key                  = "base"
  }
}

data "terraform_remote_state" "ims" {
  backend = "azurerm"

  config {
    resource_group_name  = "poc-ukwest-main-rg"
    storage_account_name = "atradius"
    container_name       = "poc-ukwest-sc"
    key                  = "ims"
  }
}
