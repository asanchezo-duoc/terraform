resource "azurerm_virtual_network" "my_vnet" {
  name                = "${var.myself}-vnet"
  address_space       = [var.cidr_network] # Define your desired CIDR block
  location            = var.region
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "my_vms_net" {
  name                 = "${var.myself}-vnet-vms"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = [var.cidr_vms_network]
}

# Interfaz de red
resource "azurerm_network_interface" "nic" {
  count               = var.create_vm ? 1 : 0
  name                = "${var.myself}-nic"
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.my_vms_net.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  count                           = var.create_vm ? 1 : 0
  name                            = "${var.myself}-vm1-linux"
  resource_group_name             = var.resource_group_name
  location                        = var.region
  size                            = "Standard_DS1_v2"
  admin_username                  = "azureuser"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.nic[0].id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Create an Azure Storage Account
resource "azurerm_storage_account" "my_storage_account" {
  count                    = var.create_storage ? 1 : 0
  name                     = replace("${var.myself}storageaccount", ".", "")
  resource_group_name      = var.resource_group_name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.my_vnet.id
}

output "vnet_name" {
  description = "The name of the Virtual Network."
  value       = azurerm_virtual_network.my_vnet.name
}

output "storage_account_name" {
  description = "The name of the Storage Account."
  value       = var.create_storage ? azurerm_storage_account.my_storage_account[0].name : null
}

output "vm_private_ip" {
  description = "The private IP address of the Virtual Machine."
  value       = var.create_vm ? azurerm_network_interface.nic[0].private_ip_address : null
}
