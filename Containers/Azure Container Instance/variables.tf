variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group"
}

variable "image_name" {
  default     = "juice-shop"
}

variable "container_port" {
  type        = number
  default     = "3000"
}

variable "ACR_login_server" {
  type = string
}

variable "ACR_username" {
  type = string
}

variable "ACR_password" {
  type = string
}

variable "acr_push_depends_on" {
  description = "Dependency to ensure ACR image is pushed before ACI deployment"
}