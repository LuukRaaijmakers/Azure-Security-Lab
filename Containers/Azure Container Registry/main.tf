resource "azurerm_container_registry" "ACR" {
  name                = "securitylabregistry1"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "null_resource" "push_image" {
  depends_on = [azurerm_container_registry.ACR]

  provisioner "local-exec" {
    command = "bash pushimage.sh"
    environment = {
      SOURCE_IMAGE = var.container_image
      TARGET_IMAGE = var.image_name
      }
  }
}