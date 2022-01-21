# Create Windows Virtual Machine 
resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "${var.client_name}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  size                  = "${var.vm_size}"
  admin_username        = "${var.admin_username}"
  admin_password        = "${var.admin_password}"
  provision_vm_agent    = "true"
  custom_data           = filebase64("${var.file_path}create-custom-host/files/custom_data.zip")
  network_interface_ids = [azurerm_network_interface.primary.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Additional setup Part 1
  additional_unattend_content {
    content = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
    setting = "AutoLogon"
  }

  # Additional setup Part 2
  additional_unattend_content {
    content = file("${var.file_path}create-custom-host/files/FirstLogonCommands.xml")
    setting = "FirstLogonCommands"
  }

  # Create Windows Image
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-pron"
    version   = "latest"
  } 

  # Create Tags 
  tags = var.tags

}