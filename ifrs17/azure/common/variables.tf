##################################################
# Variables
##################################################
variable "common_tags" {
  type = "map"

  default = {
    "Terraform" = true
    "Project"   = "infrastructure-as-code"
  }
}

variable "environment" {
  default = "poc"
}

variable "location" {
  default = "ukwest"
}

variable "storage_account_name" {
  default = "atradius"
}

##################################################
# Local(s)
##################################################
locals {
  costcenter = "${coalesce(upper(var.costcenter), "ITS")}"
  prefix     = "${var.environment}-${var.location}"
}
