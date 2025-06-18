variable "container_image" {
  type        = string
  description = "The image to use for the container."
  default     = "bkimminich/juice-shop"
}

variable "image_name" {
  default     = "juice-shop"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group"
}