resource "azurerm_virtual_network" "my_vnet" {
  name                = "${var.myself}-vnet"
  address_space       = ["10.200.0.0/16"] # Define your desired CIDR block
  location            = var.region
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "my_vms_net" {
  name                 = "${var.myself}-vnet-vms"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.200.0.0/23"]
}

# Interfaz de red
resource "azurerm_network_interface" "nic" {
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
  name                            = "${var.myself}-vm1-linux"
  resource_group_name             = var.resource_group_name
  location                        = var.region
  size                            = "Standard_DS1_v2"
  admin_username                  = "azureuser"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.nic.id]

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
  name                     = replace("${var.myself}storageaccount", ".", "")
  resource_group_name      = var.resource_group_name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
}