##################################################
# Module
##################################################
module puppet_cs {
  source              = "git@github.com:marclambrichs/terraform-azure-script-extension"
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  virtual_machines    = ["${var.virtual_machines}"]
  urls                = ["${var.urls}"]
  commands            = "${join(" ", list("./puppet_bootstrap.sh", "\\\"${var.puppetmaster_ip}\\\"", "\\\"${var.puppetmaster}\\\"", "\\\"${var.pp_environment}\\\""))}"

  tags = "${var.tags}"
}
