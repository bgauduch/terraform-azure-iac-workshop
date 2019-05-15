/**
* Global
**/
variable "azure_region" {
  description = "The Azure Region to be use"
  type        = "string"
  default     = "North Europe"
}
variable "resource_group_name" {
  description = "the resource group name"
  type        = "string"
  default     = "az_iac_rg_bga"
}
variable "environment_tag" {
  description = "the current environement tag"
  type        = "string"
  default     = "production"
}

/**
* Network
**/
variable "vnet_range" {
  description = "The ip range for the VNET"
  type        = "string"
  default     = "10.0.0.0/16"
}

/**
* VM
**/
variable "ubuntu_version" {
  description = "The Ubuntu OS version to be used on VM"
  type        = "string"
  default     = "18.04-LTS"
}
variable "vm_size" {
  description = "The Vm Size"
  type        = "string"
  default     = "Standard_A1_v2"
}
variable "user_name" {
  description = "The username on the VM"
  type        = "string"
  default     = "azureuser"
}
variable "user_password" {
  description = "The user password on the VM"
  type        = "string"
}
variable "cloudinit_script_path" {
  description = "The user password on the VM"
  type        = "string"
  default = "vm-cloud-init.yaml"
}