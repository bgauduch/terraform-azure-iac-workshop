/**
* Setup the Cloud provider
**/
provider "azurerm" {
  version = "=1.29.0"
}

/**
* Create the resource group
**/
resource "azurerm_resource_group" "az_iac_rg" {
  name     = "${var.resource_group_name}"
  location = "${var.azure_region}"

  tags {
    environment = "${var.environment_tag}"
  }
}

/**
* Create the subnet NSG
**/
resource "azurerm_network_security_group" "az_iac_nsg" {
  name                = "az_iac_nsg_bga"
  location            = "${azurerm_resource_group.az_iac_rg.location}"
  resource_group_name = "${azurerm_resource_group.az_iac_rg.name}"
}

/**
* Add a rule to the NSG: allow HTTP in
**/
resource "azurerm_network_security_rule" "az_iac_nsg_rule_http_allow" {
  name                        = "az_iac_nsg_rule_http_allow_bga"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.az_iac_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.az_iac_nsg.name}"
}

/**
* Create a vNET with it's subnet
**/
resource "azurerm_virtual_network" "az_iac_vnet" {
  name                = "az_iac_vnet_bga"
  location            = "${azurerm_resource_group.az_iac_rg.location}"
  resource_group_name = "${azurerm_resource_group.az_iac_rg.name}"
  address_space       = ["${var.vnet_range}"]

  tags {
    environment = "${var.environment_tag}"
  }
}

/**
* Create the Subnet
**/
resource "azurerm_subnet" "az_iac_subnet" {
  name                 = "az_iac_subnet_bga"
  resource_group_name  = "${azurerm_resource_group.az_iac_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.az_iac_vnet.name}"
  address_prefix       = "${cidrsubnet(var.vnet_range, 8, 1)}"

  # The following is deprecated, but fix an issue where the subnet<->NSG association is recreated at every 'terraform apply'
  # Terraform CLI will yield a deprecation warning.
  network_security_group_id = "${azurerm_network_security_group.az_iac_nsg.id}"
}

/**
* Bind the NSG to the subnet
**/
resource "azurerm_subnet_network_security_group_association" "az_iac_subnet_nsg_bind" {
  subnet_id                 = "${azurerm_subnet.az_iac_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.az_iac_nsg.id}"
}

/**
* Public IP
**/
resource "azurerm_public_ip" "az_iac_pip" {
  name                = "az_iac_pip_bga"
  location            = "${azurerm_resource_group.az_iac_rg.location}"
  resource_group_name = "${azurerm_resource_group.az_iac_rg.name}"
  ip_version          = "ipv4"
  allocation_method   = "Static"
  domain_name_label   = "azure-iac-bga"

  tags {
    environment = "${var.environment_tag}"
  }
}

/**
* NIC
**/
resource "azurerm_network_interface" "az_iac_nic" {
  name                = "az_iac_nic_bga"
  location            = "${azurerm_resource_group.az_iac_rg.location}"
  resource_group_name = "${azurerm_resource_group.az_iac_rg.name}"

  ip_configuration {
    name                          = "az_iac_nic_ip_config"
    subnet_id                     = "${azurerm_subnet.az_iac_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.az_iac_pip.id}"
  }

  tags {
    environment = "${var.environment_tag}"
  }
}

/**
* Setup Cloudinit script
**/
data "template_file" "az_iac_cloudinit_file" {
  template = "${file("${var.cloudinit_script_path}")}"
}

data "template_cloudinit_config" "az_iac_vm_cloudinit_script" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.az_iac_cloudinit_file.rendered}"
  }
}

/**
* Create VM
**/
resource "azurerm_virtual_machine" "az_iac_vm" {
  name                = "az_iac_vm_bga"
  location            = "${azurerm_resource_group.az_iac_rg.location}"
  resource_group_name = "${azurerm_resource_group.az_iac_rg.name}"

  network_interface_ids         = ["${azurerm_network_interface.az_iac_nic.id}"]
  vm_size                       = "${var.vm_size}"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "${var.ubuntu_version}"
    version   = "latest"
  }

  storage_os_disk {
    name              = "az_iac_vm_os_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "az-iac-vm-bga"
    admin_username = "${var.user_name}"
    admin_password = "${var.user_password}"
    custom_data    = "${data.template_cloudinit_config.az_iac_vm_cloudinit_script.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "${var.environment_tag}"
  }
}
