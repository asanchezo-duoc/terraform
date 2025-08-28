resource "azurerm_virtual_network" "my_vnet" {
  name                = "${var.myself}-vnet"
  address_space       = ["10.200.0.0/16"] # Define your desired CIDR block
  location            = var.region
  resource_group_name = var.resource_group_name
}