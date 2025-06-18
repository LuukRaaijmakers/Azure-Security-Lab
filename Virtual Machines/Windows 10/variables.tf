variable "admin_username_W10" {
  type        = string
  description = "Username for the admin account"
  default     = ""
}

variable "admin_password_W10" {
  type        = string
  description = "Password for the admin account"
  default     = ""
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group"
}

variable "subnet_id" {
  type        = string
  description = "subnet ID"
}