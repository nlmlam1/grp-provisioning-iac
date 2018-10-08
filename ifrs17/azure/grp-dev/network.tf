##################################################
# subnet for management
##################################################
resource "azurerm_subnet" "subnet1" {
  name                      = "${local.prefix}-grp"
  address_prefix            = "10.224.32.128/26"
  resource_group_name       = "${data.terraform_remote_state.base.main-resource-group}"
  virtual_network_name      = "${data.terraform_remote_state.base.main-vnet}"
  network_security_group_id = "${azurerm_network_security_group.grp.id}"
}

##################################################
# Network security group
##################################################
resource "azurerm_network_security_group" "grp" {
  name                = "${local.prefix}-grp-nsg"
  resource_group_name = "${azurerm_resource_group.grp.name}"
  location            = "${var.location}"

  security_rule {
    name                       = "allow_remote_22_from_bastion"
    description                = "Allow inbound tcp from bastion host"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${local.bastion_vnet}"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = "100"
    direction                  = "Inbound"
  }

  security_rule {
    name                                       = "allow_remote_web"
    description                                = "Foreman Web access - allow TCP 80,443"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_ranges                    = ["80", "443"]
    source_address_prefix                      = "*"
    destination_application_security_group_ids = ["${data.terraform_remote_state.ims.application_security_group_web}"]
    access                                     = "Allow"
    priority                                   = "102"
    direction                                  = "Inbound"
  }

  tags = "${merge(
    var.common_tags,
    map(
      "Costcenter", "${local.costcenter}",
      "Environment", "${var.environment}"
    )
  )}"
}
