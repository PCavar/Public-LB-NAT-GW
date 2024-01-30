resource "azurerm_public_ip" "lb_publicip" {
  name                = "${var.prefix}-PublicIP-LB"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "main_lb" {
  name                = "${var.prefix}-Public-LB"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_publicip.id
  }
}

resource "azurerm_lb_backend_address_pool" "main_be_pool" {
  loadbalancer_id = azurerm_lb.main_lb.id
  name            = "BackendPool"
}

// Probe is cheking health of backend resources
resource "azurerm_lb_probe" "web_lb_probe" {
  name            = "TCP-Probe"
  protocol        = "Tcp"
  port            = 80
  loadbalancer_id = azurerm_lb.main_lb.id
}

// Rule/s for loadbalancer
resource "azurerm_lb_rule" "lb_rule_http" {
  name                           = "AllowHTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.main_lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.web_lb_probe.id
  loadbalancer_id                = azurerm_lb.main_lb.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main_be_pool.id]
  enable_tcp_reset               = true
}

// Associating NIC with backend pool for loadbalancer
resource "azurerm_network_interface_backend_address_pool_association" "be_nic_lb_associate1" {
  network_interface_id    = azurerm_network_interface.vm2_nic.id
  ip_configuration_name   = azurerm_network_interface.vm2_nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.main_be_pool.id
}

// Associating NIC with backend pool for loadbalancer
resource "azurerm_network_interface_backend_address_pool_association" "be_nic_lb_associate2" {
  network_interface_id    = azurerm_network_interface.vm3_nic.id
  ip_configuration_name   = azurerm_network_interface.vm3_nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.main_be_pool.id
}
