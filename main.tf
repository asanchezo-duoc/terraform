# Configuración del provider de Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
  required_version = ">= 1.0"
}

# Configuración del provider de Azure
provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id = "bb1ccac7-d7f8-47bf-82c2-f223185cfab9"
}

# Grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "AreaInfraestructura"
  location = "East US 2"
}
