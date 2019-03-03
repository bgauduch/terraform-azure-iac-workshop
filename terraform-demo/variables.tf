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
  default     = "terraform_demo"
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