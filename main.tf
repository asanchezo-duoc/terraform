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

# Referencia al grupo de recursos existente
data "azurerm_resource_group" "rg" {
  name = "AreaInfraestructura"
}

# Variables
variable "myself" {
  description = "Dato unico para no sobre escribir cosas ajenas."
  type        = string
  default     = "a.sanchezo"
}

variable "region" {
    description = "Region"
    type        = string
    default     = "East US 2"
}

module "azure_infra" {
  source              = "./modulo-interno-azure"
  resource_group_name = data.azurerm_resource_group.rg.name
  myself              = var.myself
  region              = var.region
}

# Outputs del módulo
output "virtual_network_id" {
  description = "ID de la Virtual Network creada"
  value       = module.azure_infra.vnet_id
}

output "virtual_network_name" {
  description = "Nombre de la Virtual Network creada"
  value       = module.azure_infra.vnet_name
}

output "storage_account_name" {
  description = "Nombre de la Storage Account creada"
  value       = module.azure_infra.storage_account_name
}