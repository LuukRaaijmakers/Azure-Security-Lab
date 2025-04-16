variable "resource_group_location" {
  type        = string
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "subscription_id" {
  type        = string
  description = "The subscription id for the Azure subscription"  
}

variable "admin_username" {
  type        = string
  description = "username to the W10 VM"
}

variable "admin_password" {
  type        = string
  description = "password to the W10 VM"
}