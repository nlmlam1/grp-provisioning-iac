##################################################
# Use Custom Script Extension Puppetagent
##################################################
module puppet_cs {
  source              = "git@github.com:marclambrichs/terraform-azure-script-extension"
  name                = "puppet"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.grp.name}"

  virtual_machines = ["${module.nginx.virtual_machine_names}",
    "${module.nifi.virtual_machine_names}",
    "${module.postgresql.virtual_machine_names}",
  ]

  urls     = ["${data.terraform_remote_state.ims.puppet_script}"]
  commands = "${join(" ", list("./puppet_bootstrap.sh", "\\\"${element(data.terraform_remote_state.ims.puppetmaster_ip,0)}\\\"", "\\\"puppetmaster-0\\\"", "\\\"production\\\""))}"

  tags = "${merge(
    var.common_tags,
    map(
      "Costcenter", "${local.costcenter}",
      "Environment", "${var.environment}"
    )
  )}"
}

##################################################
# Virtual Machine NiFi
##################################################
module nifi {
  source   = "git@github.com:AtradiusGroup/terraform-azure-compute?ref=IT-59-bootstrap-puppetmaster-in-the-cloud"
  location = "${var.location}"

  nr_of_instances     = 1
  nr_of_public_ip     = 0
  resource_group_name = "${azurerm_resource_group.grp.name}"
  ssh_key             = "~/.ssh/id_rsa_atradius.pub"

  application_security_group_ids = []

  availability_set  = "true"
  boot_diagnostics  = "false"
  data_disk         = "true"
  data_disk_size_gb = 50
  data_disk_type    = "Standard_LRS"

  tags = "${merge(
    var.common_tags,
    map(
      "Costcenter", "${local.costcenter}",
      "Environment", "${var.environment}"
    )
  )}"

  vm_hostname    = "${var.subnet_name}-streaming"
  vm_size        = "Standard_E4s_v3"
  vnet_subnet_id = "${azurerm_subnet.subnet1.id}"
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
    "${data.terraform_remote_state.ims.application_security_group_web}",
  ]

  tags = "${merge(
    var.common_tags,
    map(
      "Costcenter", "${local.costcenter}",
      "Environment", "${var.environment}"
    )
  )}"

  vm_hostname    = "${var.subnet_name}-website"
  vm_size        = "Standard_B1s"
  vnet_subnet_id = "${azurerm_subnet.subnet1.id}"
}
