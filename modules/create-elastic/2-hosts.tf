# Create Linux Client Virtual Machines
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.vm_name}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = "${var.vm_size}"
  admin_username        = "${var.admin_username}"
  admin_password        = "${var.admin_password}"
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.linux-nic.id]

  # Cloud-init
  custom_data           = filebase64("${var.file_path}create-elastic/files/cloud-init.yml")

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

  # Create Tags 
  tags = var.tags
}