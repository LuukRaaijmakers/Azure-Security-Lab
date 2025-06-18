output "kali_vm_public_ip" {
  value = azurerm_public_ip.kali_public_ip.ip_address
}