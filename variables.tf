#========================================Resource-Group========================================#

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
  default     = ""
}

#========================================Credentials========================================#

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

variable "admin_username_Kali" {
  type        = string
  description = "Username for the admin account"
  default     = ""
}

variable "admin_password_Kali" {
  type        = string
  description = "Password for the admin account"
  default     = ""
}

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

#========================================Docker-Images========================================#

variable "container_image" {
  type        = string
  description = "The image to use for the container."
  default     = "bkimminich/juice-shop"
}

variable "image_name" {
  default     = "juice-shop"
}

variable "container_port" {
  type        = number
  default     = "3000"
}