resource "azurerm_public_ip" "natgw_public_ip" {
  name                = "${var.prefix}-Nat-Gateway-Public-IP"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = "${var.prefix}-Nat-Gateway"
  location                = azurerm_resource_group.main_rg.location
  resource_group_name     = azurerm_resource_group.main_rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 15
}

resource "azurerm_nat_gateway_public_ip_association" "natgw_pip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.natgw_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "natgw_subnet_association" {
  subnet_id      = azurerm_subnet.subnet_backend.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
