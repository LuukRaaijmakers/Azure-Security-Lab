variable "admin_username_Docker" {
  type        = string
  description = "Username for the admin account"
  default     = ""
}

variable "admin_password_Docker" {
  type        = string
  description = "Password for the admin account"
  default     = ""
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID"
}