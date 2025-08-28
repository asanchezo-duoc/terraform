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

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "create_vm" {
  description = "Crear máquina virtual"
  type        = bool
  default     = false
}

variable "create_storage" {
  description = "Indica si crear el Storage Account o no"
  type        = bool
  default     = false
}