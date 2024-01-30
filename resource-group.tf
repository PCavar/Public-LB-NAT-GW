resource "azurerm_resource_group" "main_rg" {
  name     = var.main_rg
  location = var.region
}
