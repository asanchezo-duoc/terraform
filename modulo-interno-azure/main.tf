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