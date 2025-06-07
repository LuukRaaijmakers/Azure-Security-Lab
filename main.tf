
# Create a resource group
resource "azurerm_resource_group" "RG-SecurityLab" {
  location = var.resource_group_location
  name = "RG-SecurityLab"
}

#Networking
resource "azurerm_public_ip" "win_public_ip" {
  name                = "win-public-ip"
  location            = azurerm_resource_group.RG-SecurityLab.location
  resource_group_name = azurerm_resource_group.RG-SecurityLab.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_public_ip" "kali_public_ip" {
  name                = "kali-public-ip"
  location            = azurerm_resource_group.RG-SecurityLab.location
  resource_group_name = azurerm_resource_group.RG-SecurityLab.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

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


#Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "NSG-SecurityLab"
  location            = azurerm_resource_group.RG-SecurityLab.location
  resource_group_name = azurerm_resource_group.RG-SecurityLab.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NSG association
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.Subnet-SecurityLab.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


#Virtual Machine W10

resource "azurerm_network_interface" "NIC-W10VM" {
  name                = "W10VM-nic"
  location            = azurerm_resource_group.RG-SecurityLab.location
  resource_group_name = azurerm_resource_group.RG-SecurityLab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet-SecurityLab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.win_public_ip.id
  }
}


resource "azurerm_windows_virtual_machine" "W10" {
  name                = "VM-W10"
  resource_group_name = azurerm_resource_group.RG-SecurityLab.name
  location            = azurerm_resource_group.RG-SecurityLab.location
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
}

#Linux VM

resource "azurerm_network_interface" "NIC-KaliVM" {
  name                = "Kali-nic"
  location            = azurerm_resource_group.RG-SecurityLab.location
  resource_group_name = azurerm_resource_group.RG-SecurityLab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet-SecurityLab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.kali_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "Kali-Linux" {
  name                = "Kali-Linux"
  resource_group_name = azurerm_resource_group.RG-SecurityLab.name
  location            = azurerm_resource_group.RG-SecurityLab.location
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

output "kali_vm_public_ip" {
  value = azurerm_public_ip.kali_public_ip.ip_address
}
