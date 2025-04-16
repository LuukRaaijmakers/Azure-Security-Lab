
# Create a resource group
resource "azurerm_resource_group" "resource_group" {
  location = var.resource_group_location
  name = "RG-SecurityLab"
}

