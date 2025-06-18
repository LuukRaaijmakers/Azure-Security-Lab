resource "azurerm_public_ip" "Docker_public_ip" {
  name                = "Docker-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Docker VM
resource "azurerm_network_interface" "NIC-DockerVM" {
  name                = "Docker-nic"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.30"
    public_ip_address_id          = azurerm_public_ip.Docker_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "DockerVM" {
  name                = "Docker"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username_Docker
  admin_password      = var.admin_password_Docker
  network_interface_ids = [
    azurerm_network_interface.NIC-DockerVM.id
  ]

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOT
    #!/bin/bash
    
    echo 'libraries/restart-without-asking boolean true' | sudo debconf-set-selections
    
    apt update 
    
    DEBIAN_FRONTEND=noninteractive apt upgrade -y

    # Install the latest version docker
    curl -s https://get.docker.com/ | sh

    # Run docker service
    systemctl start docker
      
    #Install git
    DEBIAN_FRONTEND=noninteractive apt install git

    # Get the vulnhub repo
    su - DockerAdmin -c "git clone --depth 1 https://github.com/vulhub/vulhub ~/vulhub"

    cd /home/DockerAdmin/vulhub/langflow/CVE-2025-3248
    
    docker compose up -d

    #install Wazuh all-in-one deployment
    curl -sO https://packages.wazuh.com/4.12/wazuh-install.sh && sudo bash ./wazuh-install.sh -a

    cd /usr/share/wazuh-indexer/plugins/opensearch-security/tools/

    bash wazuh-passwords-tool.sh -u admin -p Secr3tP4ssw*rd

    systemctl restart wazuh-dashboard

  EOT
  )
}