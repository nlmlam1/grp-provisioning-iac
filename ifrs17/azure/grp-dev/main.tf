##################################################
# Providers
##################################################
provider "azurerm" {
  environment = "public"
}

provider "random" {
  version = "~> 1.3.1"
}

provider "template" {
  version = "1.0.0"
}

##################################################
# Azure resource group
##################################################
resource "azurerm_resource_group" "grp" {
  name     = "${local.prefix}-${var.subnet_name}-rg"
  location = "${var.location}"

  tags = "${local.tags}"
}
