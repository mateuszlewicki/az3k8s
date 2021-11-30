output "master_ip" {
  value = azurerm_linux_virtual_machine.kmaster.public_ip_address
}
