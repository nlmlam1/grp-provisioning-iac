##################################################
# Container to hold nifi data
##################################################
resource "azurerm_storage_container" "nifi" {
  name                  = "${local.prefix}-nifi-sc"
  resource_group_name   = "${data.terraform_remote_state.base.storage-resource-group}"
  storage_account_name  = "${var.storage_account_name}"
  container_access_type = "blob"
}

##################################################
# NiFi blob
##################################################
resource "azurerm_storage_blob" "nifi" {
  name                   = "${local.prefix}-nifi-blob"
  resource_group_name    = "${data.terraform_remote_state.base.storage-resource-group}"
  storage_account_name   = "${data.terraform_remote_state.ims.storage_account_name}"
  storage_container_name = "${azurerm_storage_container.nifi.name}"
  type                   = "block"
}
