output "Windows10_vm_public_ip" {
  value = azurerm_public_ip.win_public_ip.ip_address
}