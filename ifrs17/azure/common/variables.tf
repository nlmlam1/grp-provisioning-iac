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

variable "costcenter" {
  default = ""
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
  costcenter           = "${coalesce(upper(var.costcenter), "GRP")}"
  prefix               = "${var.environment}-${var.location}"
  puppet_bootstrap_url = "${data.terraform_remote_state.ims.puppet_script}"

  tags = "${merge(
    var.common_tags,
    map(
      "Costcenter", "${local.costcenter}",
      "Environment", "${var.environment}"
    )
  )}"
}
