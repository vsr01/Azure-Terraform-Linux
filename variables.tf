variable "project" {
  description = "Project/application name used for naming."
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus2"
}

variable "vm_size" {
  description = "VM size. Default is a common 16 GB general-purpose size."
  type        = string
  default     = "Standard_D4as_v7"
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
  default     = ["10.10.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Subnet prefixes."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "tags" {
  description = "Tags for resources."
  type        = map(string)
  default     = {}
}

