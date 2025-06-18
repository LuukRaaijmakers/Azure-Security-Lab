#========================================Subscription========================================#

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
}

variable "admin_password_Kali" {
  type        = string
  description = "Password for the admin account"
}

variable "admin_username_Docker" {
  type        = string
  description = "Username for the admin account"
}

variable "admin_password_Docker" {
  type        = string
  description = "Password for the admin account"
}

# #========================================Docker-Images========================================#

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