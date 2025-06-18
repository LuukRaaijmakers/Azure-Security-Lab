resource "azurerm_resource_group" "RG-SecurityLab" {
  name = var.resource_group_name
  location = var.resource_group_location
}