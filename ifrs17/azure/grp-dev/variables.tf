##################################################
# Variables
##################################################
variable "costcenter" {
  default = "grp"
}

variable "subnet_name" {
  default = "grp"
}

##################################################
# Local(s)
##################################################
locals {
  bastion_vnet = "${cidrsubnet(data.terraform_remote_state.base.main-address-space[0],5,1)}"
}
