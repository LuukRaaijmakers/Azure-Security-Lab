terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.26.0"
    }
  }
}

#This block enables interaction with the Azure API
provider "azurerm" { 
  features {}
}

