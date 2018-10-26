##################################################
# Variables
##################################################
variable "agent_count" {
  default = 3
}

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default = ""
}

variable "cluster_name" {
  default = "k8s"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa_atradius.pub"
}

variable "subnet_name" {
  default = "grp"
}

##################################################
# Local(s)
##################################################
locals {
  bastion_vnet = "${cidrsubnet(data.terraform_remote_state.base.main-address-space[0],5,1)}"
  dns_prefix   = "${var.subnet_name}-k8s"
}
