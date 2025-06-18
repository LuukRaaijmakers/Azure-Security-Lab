resource "azurerm_container_group" "SecuritylabContainer" {
  name                = "container"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  ip_address_type     = "Public"
  dns_name_label      = "aci-label-demo-${random_id.dns.hex}"
  os_type             = "Linux"
  depends_on          = [var.acr_push_depends_on]

  
  image_registry_credential {
    server   = var.ACR_login_server
    username = var.ACR_username
    password = var.ACR_password
  }

  container {
    name   = "securitylab-container"
    image = "securitylabregistry1.azurecr.io/${var.image_name}:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = var.container_port
      protocol = "TCP"
    }
  }
}

resource "random_id" "dns" {
  byte_length = 4
}