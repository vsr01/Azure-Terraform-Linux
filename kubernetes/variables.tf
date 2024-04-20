variable "project" {
  description = "Project/application name used for naming."
  type        = string
  default     = "kubernetes"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "southcentralus"
}

variable "vm_size" {
  description = "VM size."
  type        = string
  default     = "Standard_F8amds_v7"
}

variable "admin_username" {
  description = "Linux admin username."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "Full SSH public key text. Leave empty to use ssh_public_key_path."
  type        = string
  default     = ""
}

variable "ssh_public_key_path" {
  description = "Absolute path to SSH public key file (.pub)."
  type        = string
  default     = ""
}

variable "ssh_private_key_path" {
  description = "Local private key path used in output ssh command."
  type        = string
  default     = "~/.ssh/azure-dev-vm"
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed for SSH."
  type        = string
  default     = "0.0.0.0/0"
}

variable "vnet_address_space" {
  description = "VNet address space."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Subnet prefixes."
  type        = list(string)
  default     = ["10.20.1.0/24"]
}

variable "tags" {
  description = "Tags for resources."
  type        = map(string)
  default     = {}
}
