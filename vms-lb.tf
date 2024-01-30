##VM2 - LB
resource "azurerm_network_interface" "vm2_nic" {
  name                = "${var.prefix}-vm2-nic2"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm2" {
  name                = "${var.prefix}-vm2"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = var.vm_password
  network_interface_ids = [
    azurerm_network_interface.vm2_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "powershell_script_vm2" {
  name                 = "Install-IIS"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm2.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/PCavar/Public-LB-NAT-GW/main/install-iis.ps1"],
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File install-iis.ps1"
    }
  SETTINGS
}

##VM3 - LB
resource "azurerm_network_interface" "vm3_nic" {
  name                = "${var.prefix}-vm3-nic3"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm3" {
  name                = "${var.prefix}-vm3"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = var.vm_password
  network_interface_ids = [
    azurerm_network_interface.vm3_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "powershell_script_vm3" {
  name                 = "Install-IIS"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm3.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/PCavar/Public-LB-NAT-GW/main/install-iis.ps1"],
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File install-iis.ps1"
    }
  SETTINGS
}
