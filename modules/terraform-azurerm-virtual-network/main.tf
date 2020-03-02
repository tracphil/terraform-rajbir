
module azurerm_virtual_network_label {
  source = "../terraform-null-label"

  attributes = var.attributes
  delimiter  = var.delimiter
  location   = var.location
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}


resource azurerm_virtual_network virtual_network {
  address_space       = [var.address_space]
  location            = module.azurerm_virtual_network_label.location
  name                = "vnet-${module.azurerm_virtual_network_label.id}"
  resource_group_name = var.resource_group_name

  tags = module.azurerm_virtual_network_label.tags
}
