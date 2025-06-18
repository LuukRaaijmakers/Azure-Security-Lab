output "container_registry_login_server" {
  value = azurerm_container_registry.ACR.login_server
}

output "container_registry_username" {
  value = azurerm_container_registry.ACR.admin_username
}

output "container_registry_password" {
  value = azurerm_container_registry.ACR.admin_password
}

output "push_image" {
  value = null_resource.push_image
}

output "ACR" {
  value = azurerm_container_registry.ACR
}