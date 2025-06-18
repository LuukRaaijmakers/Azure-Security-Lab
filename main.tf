#========================================Providers========================================#
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" { 
  features {}
  subscription_id = var.subscription_id 
}

#========================================Modules========================================#

module "resource_group"{
  source = "./Misc/Resource Group"
  resource_group_name         = "RG-SecurityLab"
  resource_group_location     = "westeurope"    
}

module "networking" {
  source = "./Misc/Networking"
  resource_group_name         = module.resource_group.name
  resource_group_location     = module.resource_group.location
}

module "ubuntu_2204_TLS" {
  source = "./Virtual Machines/Ubuntu 22.04 LTS"
  resource_group_name         = module.resource_group.name
  resource_group_location     = module.resource_group.location
  subnet_id                   = module.networking.subnet_id
  admin_username_Docker       = var.admin_username_Docker
  admin_password_Docker       = var.admin_password_Docker
}

module "Kali_Linux" {
  source = "./Virtual Machines/Kali-Linux"
  resource_group_name         = module.resource_group.name
  resource_group_location     = module.resource_group.location
  subnet_id                   = module.networking.subnet_id
  admin_username_Kali         = var.admin_username_Kali
  admin_password_Kali         = var.admin_password_Kali
}

module "Windows_10" {
  source = "./Virtual Machines/Windows 10"
  resource_group_name         = module.resource_group.name
  resource_group_location     = module.resource_group.location
  subnet_id                   = module.networking.subnet_id
  admin_username_W10          = var.admin_username_W10
  admin_password_W10          = var.admin_password_W10
}

module "Azure_Container_Registry" {
  source = "./Containers/Azure Container Registry"
  resource_group_name         = module.resource_group.name
  resource_group_location     = module.resource_group.location
  image_name                  = var.image_name
  container_image             = var.container_image
}

module "Azure_Container_Instance" {
  source = "./Containers/Azure Container Instance"
  resource_group_name         = module.resource_group.name
  resource_group_location     = module.resource_group.location
  image_name                  = var.image_name
  container_port              = var.container_port

  ACR_login_server            = module.Azure_Container_Registry.container_registry_login_server
  ACR_username                = module.Azure_Container_Registry.container_registry_username
  ACR_password                = module.Azure_Container_Registry.container_registry_password
  acr_push_depends_on         = module.Azure_Container_Registry.push_image
}