# Create Windows Virtual Machine 
resource "azurerm_windows_virtual_machine" "vm" {
  for_each              = toset(var.windows_vm_name)
  name                  = "${each.value}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  size                  = "Standard_D1_v2"
  admin_username        = "${var.admin_username}"
  admin_password        = "${var.admin_password}"
  provision_vm_agent    = "true"
  custom_data           = filebase64("${var.file_path}create-windows-hosts/files/custom_data.zip")
  network_interface_ids = [azurerm_network_interface.primary[each.key].id]

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
    content = file("~/Documents/Terraform/CSOC-Labv4/modules/create-windows-hosts/files/FirstLogonCommands.xml")
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


