/**
* Setup the Cloud provider
**/
provider "azurerm" {
  // static values
  version = "=1.22.1"
}

/**
* Create the resource group
**/
resource "azurerm_resource_group" "terraform_demo_rg" {
  // for more flexibility, use variables
  name     = "${var.resource_group_name}"
  location = "${var.azure_region}"

  tags {
    environment = "${var.environment_tag}"
  }
}

/**
* Create a vNET
**/
resource "azurerm_virtual_network" "terraform_demo_vnet" {
  name                = "terraform_demo_vnet"
  
  # link on resource attribut for dependancy handling
  location            = "${azurerm_resource_group.terraform_demo_rg.location}"
  resource_group_name = "${azurerm_resource_group.terraform_demo_rg.name}"     

  address_space = ["${var.vnet_range}"]
}