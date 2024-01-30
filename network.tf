resource "azurerm_virtual_network" "main_vnet" {
  name                = "${var.prefix}-${var.main_vnet["vnet1"].vnet_name}"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  address_space       = [var.main_vnet["vnet1"].vnet_cidr]
  tags = {
    Environment = "Dev"
  }
}

resource "azurerm_subnet" "subnet_backend" {
  name                 = var.main_vnet["vnet1"].backendsubnet_1_name
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = [var.main_vnet["vnet1"].backendsubnet_1_cidr]
}

resource "azurerm_subnet" "subnet_bastion" {
  name                 = var.main_vnet["vnet1"].subnet_bastion_name
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = [var.main_vnet["vnet1"].subnet_bastion_cidr]
}
