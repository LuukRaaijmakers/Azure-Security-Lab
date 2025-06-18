resource "azurerm_public_ip" "kali_public_ip" {
  name                = "kali-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Kali-Linux
resource "azurerm_network_interface" "NIC-KaliVM" {
  name                = "Kali-nic"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.20"
    public_ip_address_id          = azurerm_public_ip.kali_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "Kali-Linux" {
  name                = "Kali-Linux"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = "Standard_DS1_v2"
  admin_username      = var.admin_username_Kali
  admin_password      = var.admin_password_Kali
  network_interface_ids = [
    azurerm_network_interface.NIC-KaliVM.id,
  ]

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "kali-linux"
    offer     = "kali"
    sku       = "kali-2024-4"
    version   = "2024.4.1"
  }

  plan {
    name      = "kali-2024-4"
    publisher = "kali-linux"
    product   = "kali"
  }

  # installs default kali tools, rdp support and a desktop environment on first boot:
  custom_data = base64encode(<<-EOT
    #!/bin/bash

    # Add new GPG key
    wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg

    echo 'libraries/restart-without-asking boolean true' | sudo debconf-set-selections

    apt update 

    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
    DEBIAN_FRONTEND=noninteractive apt-get install -y kali-linux-default
    DEBIAN_FRONTEND=noninteractive apt-get install -y kali-desktop-gnome xrdp
    systemctl set-default graphical.target
    systemctl enable xrdp
    systemctl start xrdp
    reboot
  EOT
  )

}