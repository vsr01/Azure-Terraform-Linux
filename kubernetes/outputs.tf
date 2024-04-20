output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "vm_public_ip" {
  description = "Public IP address assigned to the VM."
  value       = azurerm_public_ip.vm.ip_address
}

output "ssh_command" {
  description = "SSH command to connect from local machine."
  value       = "ssh -i ${var.ssh_private_key_path} ${var.admin_username}@${azurerm_public_ip.vm.ip_address}"
}
