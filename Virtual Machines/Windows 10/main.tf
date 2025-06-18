resource "azurerm_public_ip" "win_public_ip" {
  name                = "win-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Windows 10 VM
resource "azurerm_network_interface" "NIC-W10VM" {
  name                = "W10VM-nic"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.10"
    public_ip_address_id          = azurerm_public_ip.win_public_ip.id
  }
}

resource "azurerm_virtual_machine_extension" "install_wazuh_agent" {
  name                 = "install-wazuh-agent"
  virtual_machine_id   = azurerm_windows_virtual_machine.W10.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on           = [azurerm_windows_virtual_machine.W10]

  settings = jsonencode({
    "fileUris" = ["https://raw.githubusercontent.com/LuukRaaijmakers/Azure-Security-Lab/refs/heads/main/installagent.ps1"],
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File installagent.ps1"
  })

}

resource "azurerm_windows_virtual_machine" "W10" {
  name                = "VM-W10"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username_W10
  admin_password      = var.admin_password_W10
  network_interface_ids = [
    azurerm_network_interface.NIC-W10VM.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-24h2-pro"
    version   = "latest"
  }
  
  # Installs the Azure agent that allows the custom_data to be used in the machine
  provision_vm_agent = true

}