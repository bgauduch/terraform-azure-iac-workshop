/**
* expose the vnet informations
*/
output "vnet_id" {
  value = "${azurerm_virtual_network.terraform_demo_vnet.id}"
}
output "vnet_name" {
  value = "${azurerm_virtual_network.terraform_demo_vnet.name}"
}