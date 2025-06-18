output "Docker_vm_public_ip" {
  value = azurerm_public_ip.Docker_public_ip.ip_address
}

output "Docker_vm_private_ip" {
  value = azurerm_network_interface.NIC-DockerVM.private_ip_address
}