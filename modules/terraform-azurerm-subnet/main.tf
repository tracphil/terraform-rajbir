
module azurerm_subnet_label {
  source = "../terraform-null-label"

  attributes = var.attributes
  delimiter  = var.delimiter
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

# Alternate Name
# name                 = "snet-${module.azurerm_subnet_label.id}-${substr(var.address_prefix[count.index], 0, length(var.address_prefix[count.index]) - 3)}"
resource azurerm_subnet subnet {
  count = length(var.address_prefix)

  address_prefix       = var.address_prefix[count.index]
  name                 = "snet-${module.azurerm_subnet_label.id}-${format("%02d", count.index + 1)}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}
