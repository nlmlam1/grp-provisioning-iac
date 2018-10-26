variable "pp_environment" {
  description = "Defines the puppet environment the bootstrap will take you to."
  default     = "production"
}

variable "pp_role" {
  description = "Defines the puppet environment the bootstrap will take you to."
  default     = "production"
}

variable "location" {
  description = "The location of the network where the VM is going to be created in."
  default     = ""
}

variable "name" {
  description = "The name of this script extension."
  default     = ""
}

variable "puppetmaster" {
  description = "The name of a puppetmaster."
  default     = "puppetmaster-0"
}

variable "puppetmaster_ip" {
  description = "The ip address of the puppetmaster."
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  default     = "terraform-compute"
}

variable "tags" {
  type        = "map"
  description = "Tags to attach to this resource."
  default     = {}
}

variable "urls" {
  type        = "list"
  description = "List of script urls."
  default     = []
}

variable "virtual_machines" {
  type        = "list"
  description = "List of virtual machine names that need this extension."
  default     = []
}
