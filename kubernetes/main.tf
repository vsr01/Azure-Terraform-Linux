locals {
  name_prefix = "${var.project}-${var.environment}"
  rg_name     = "rg-${local.name_prefix}"

  default_tags = merge(
    {
      project     = var.project
      environment = var.environment
      managed_by  = "terraform"
    },
    var.tags
  )

  ssh_public_key_resolved = trimspace(
    var.ssh_public_key != "" ? var.ssh_public_key : try(file(var.ssh_public_key_path), "")
  )
}

resource "azurerm_resource_group" "this" {
  name     = local.rg_name
  location = var.location
  tags     = local.default_tags
}

resource "azurerm_virtual_network" "vm" {
  name                = "vnet-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
  tags                = local.default_tags
}

resource "azurerm_subnet" "vm" {
  name                 = "snet-${local.name_prefix}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.vm.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_public_ip" "vm" {
  name                = "pip-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.default_tags
}

resource "azurerm_network_security_group" "vm" {
  name                = "nsg-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.default_tags
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.ssh_allowed_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.vm.name
}

resource "azurerm_network_interface" "vm" {
  name                = "nic-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.default_tags

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }
}

resource "azurerm_network_interface_security_group_association" "vm" {
  network_interface_id      = azurerm_network_interface.vm.id
  network_security_group_id = azurerm_network_security_group.vm.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.vm.id
  ]
  disable_password_authentication = true
  tags                            = local.default_tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = local.ssh_public_key_resolved
  }

  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = 200
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  lifecycle {
    precondition {
      condition = can(regex(
        "^(ssh-rsa|ssh-ed25519|ecdsa-sha2-nistp256|ecdsa-sha2-nistp384|ecdsa-sha2-nistp521)\\s+",
        local.ssh_public_key_resolved
      ))
      error_message = "Provide a valid SSH public key via ssh_public_key or ssh_public_key_path."
    }
  }
}
