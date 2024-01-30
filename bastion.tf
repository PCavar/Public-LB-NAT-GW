## Resources for Azure Bastion
resource "azurerm_public_ip" "bastion_ip" {
  name                = "${var.prefix}-Bastion-PIP"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "main_bastion" {
  name                = "${var.prefix}-Bastion"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  ip_configuration {
    name                 = "${var.prefix}-configuration"
    subnet_id            = azurerm_subnet.subnet_bastion.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}
