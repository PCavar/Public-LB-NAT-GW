//NSG Bastion VM
resource "azurerm_network_security_group" "nsg_one" {
  name                = "${var.prefix}-${var.nsg-1}"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
}

resource "azurerm_network_interface_security_group_association" "vnet1_vm1_nic" {
  network_interface_id      = azurerm_network_interface.vm1_nic.id
  network_security_group_id = azurerm_network_security_group.nsg_one.id
}

resource "azurerm_network_security_rule" "vnet1_sub1_rule1" {
  name                        = "AllowRDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "20.0.3.0/27"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_one.name
}

resource "azurerm_network_security_rule" "vnet1_sub1_rule2" {
  name                        = "AllowSSH"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "20.0.3.0/27"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_one.name
}

resource "azurerm_network_security_rule" "internet_rule_deny_nsg_one" {
  name                        = "Deny-Internet-All"
  priority                    = 115
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_one.name
}

//NSG VMs LB
resource "azurerm_network_security_group" "nsg_lb" {
  name                = "${var.prefix}-${var.nsg-lb}"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
}

resource "azurerm_subnet_network_security_group_association" "backendsubnet_nsg_lb" {
  subnet_id                 = azurerm_subnet.subnet_backend.id
  network_security_group_id = azurerm_network_security_group.nsg_lb.id
}

resource "azurerm_network_security_rule" "nsg_lb_rule" {
  name                        = "AllowHTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_lb.name
}
