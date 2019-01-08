##################################################
# Virtual Machine NiFi
##################################################
module nifi {
  source   = "git@github.com:AtradiusGroup/terraform-azure-compute?ref=IT-59-bootstrap-puppetmaster-in-the-cloud"
  location = "${var.location}"

  nr_of_instances                = 1
  nr_of_public_ip                = 0
  resource_group_name            = "${azurerm_resource_group.grp.name}"
  ssh_key                        = "~/.ssh/id_rsa_atradius.pub"
  application_security_group_ids = []
  availability_set               = "true"
  boot_diagnostics               = "false"
  data_disk                      = "true"
  data_disk_size_gb              = 50
  data_disk_type                 = "Standard_LRS"
  tags                           = "${local.tags}"
  vm_hostname                    = "${var.subnet_name}-streaming"
  vm_size                        = "Standard_E4s_v3"
  vnet_subnet_id                 = "${azurerm_subnet.subnet1.id}"
}

module puppet_cs_nifi {
  source              = "../modules/puppet_cs"
  name                = "puppet_nifi"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.grp.name}"
  virtual_machines    = ["${module.nifi.virtual_machine_names}"]
  urls                = ["${local.puppet_bootstrap_url}"]
  puppetmaster_ip     = "${element(data.terraform_remote_state.ims.puppetmaster_ip,0)}"
  tags                = "${local.tags}"
}

module dns_nifi {
  source    = "../modules/dns_records"
  names     = ["nifi0"]
  addresses = "${module.nginx.network_interface_private_ip}"
  key_name = "${var.key_name}"
  key_secret = "${var.key_secret}"
  zone       = "${var.zone}"
}

##################################################
# Virtual Machine nginx
##################################################
module nginx {
  source   = "git@github.com:AtradiusGroup/terraform-azure-compute?ref=IT-59-bootstrap-puppetmaster-in-the-cloud"
  location = "${var.location}"

  nr_of_instances      = 1
  nr_of_public_ip      = 0
  resource_group_name  = "${azurerm_resource_group.grp.name}"
  ssh_key              = "~/.ssh/id_rsa_atradius.pub"
  storage_account_type = "Standard_LRS"

  application_security_group_ids = [
    "${data.terraform_remote_state.base.application_security_groups.web}",
  ]

  tags           = "${local.tags}"
  vm_hostname    = "${var.subnet_name}-website"
  vm_size        = "Standard_B1ms"
  vnet_subnet_id = "${azurerm_subnet.subnet1.id}"
}

module puppet_cs_nginx {
  source              = "../modules/puppet_cs"
  name                = "puppet_nginx"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.grp.name}"
  virtual_machines    = ["${module.nginx.virtual_machine_names}"]
  urls                = ["${local.puppet_bootstrap_url}"]
  puppetmaster_ip     = "${element(data.terraform_remote_state.ims.puppetmaster_ip,0)}"
  tags                = "${local.tags}"
}

module dns_nginx {
  source     = "../modules/dns_records"
  names      = ["proxy", "nifi"]
  addresses  = "${module.nginx.network_interface_private_ip}"
  key_name   = "${var.key_name}"
  key_secret = "${var.key_secret}"
  zone       = "${var.zone}"
}

##################################################
# Virtual Machines kubernetes cluster
##################################################
module k8s_controller {
  source   = "git@github.com:AtradiusGroup/terraform-azure-compute?ref=IT-59-bootstrap-puppetmaster-in-the-cloud"
  location = "${var.location}"

  nr_of_instances                = 3
  nr_of_public_ip                = 0
  resource_group_name            = "${azurerm_resource_group.grp.name}"
  ssh_key                        = "~/.ssh/id_rsa_atradius.pub"
  storage_account_type           = "Standard_LRS"
  application_security_group_ids = []
  availability_set               = false
  tags                           = "${local.tags}"
  vm_hostname                    = "${var.subnet_name}-hypervisor"
  vm_size                        = "Standard_B2ms"
  vnet_subnet_id                 = "${azurerm_subnet.subnet1.id}"
}

module puppet_cs_k8s_controller {
  source              = "../modules/puppet_cs"
  name                = "puppet_k8s_controller"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.grp.name}"
  virtual_machines    = ["${module.k8s_controller.virtual_machine_names}"]
  urls                = ["${local.puppet_bootstrap_url}"]
  puppetmaster_ip     = "${element(data.terraform_remote_state.ims.puppetmaster_ip,0)}"
  tags                = "${local.tags}"
}

##################################################
# Virtual Machine postgresql
##################################################
module postgresql {
  source   = "git@github.com:AtradiusGroup/terraform-azure-compute?ref=IT-59-bootstrap-puppetmaster-in-the-cloud"
  location = "${var.location}"

  nr_of_instances      = 1
  nr_of_public_ip      = 0
  resource_group_name  = "${azurerm_resource_group.grp.name}"
  ssh_key              = "~/.ssh/id_rsa_atradius.pub"
  storage_account_type = "Standard_LRS"

  application_security_group_ids = [
    "${data.terraform_remote_state.base.application_security_groups.postgresql}",
  ]

  data_disk         = "true"
  data_disk_size_gb = 500
  data_disk_type    = "Standard_LRS"
  tags              = "${local.tags}"
  vm_hostname       = "${var.subnet_name}-database"
  vm_size           = "Standard_E8s_v3"
  vnet_subnet_id    = "${azurerm_subnet.subnet1.id}"
}

module puppet_cs_pgsql {
  source              = "../modules/puppet_cs"
  name                = "puppet_postgresql"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.grp.name}"
  virtual_machines    = ["${module.postgresql.virtual_machine_names}"]
  urls                = ["${local.puppet_bootstrap_url}"]
  puppetmaster_ip     = "${element(data.terraform_remote_state.ims.puppetmaster_ip,0)}"
  tags                = "${local.tags}"
}

module dns_a_pgsql {
  source     = "../modules/dns_records"
  names      = ["db1"]
  addresses  = "${module.postgresql.network_interface_private_ip}"
  key_name   = "${var.key_name}"
  key_secret = "${var.key_secret}"
  zone       = "${var.zone}"
}
