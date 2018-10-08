##################################################
# Puppet bootstrap
##################################################
resource "azurerm_storage_blob" "puppet" {
  name                   = "puppet_bootstrap.sh"
  resource_group_name    = "${data.terraform_remote_state.base.storage-resource-group}"
  storage_account_name   = "${data.terraform_remote_state.ims.storage_account_name}"
  storage_container_name = "${data.terraform_remote_state.ims.storage_container_scripts}"
  type                   = "block"
  source                 = "../../scripts/puppet_bootstrap.sh"
}
