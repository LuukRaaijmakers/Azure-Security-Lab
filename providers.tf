terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

#This block  initializes the Azure provider 
provider "azurerm" { 
  features {}
  subscription_id = var.subscription_id 
}