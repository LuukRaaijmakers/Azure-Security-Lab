
# Create a resource group
resource "azurerm_resource_group" "RG-SecurityLab" {
  location = var.resource_group_location
  name = "RG-SecurityLab"
}

#Networking
resource "azurerm_virtual_network" "Vnet-SecurityLab" {
  name                = "Vnet-SecurityLab"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RG-SecurityLab.location
  resource_group_name = azurerm_resource_group.RG-SecurityLab.name
}

resource "azurerm_subnet" "Subnet-SecurityLab" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.RG-SecurityLab.name
  virtual_network_name = azurerm_virtual_network.Vnet-SecurityLab.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "NIC-W10VM" {
  name                = "W10VM-nic"
  location            = azurerm_resource_group.RG-SecurityLab.location
  resource_group_name = azurerm_resource_group.RG-SecurityLab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet-SecurityLab.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Virtual Machine W10
resource "azurerm_windows_virtual_machine" "W10" {
  name                = "VM-W10"
  resource_group_name = azurerm_resource_group.RG-SecurityLab.name
  location            = azurerm_resource_group.RG-SecurityLab.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
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
}