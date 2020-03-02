
module azurerm_resource_group_label {
  source = "../terraform-null-label"

  attributes = var.attributes
  delimiter  = var.delimiter
  location   = var.location
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}


resource azurerm_resource_group resource_group {
  location = var.location
  name     = "rg-${module.azurerm_resource_group_label.id}"

  tags = module.azurerm_resource_group_label.tags
}


resource azurerm_management_lock resource_group_management_lock {
  # If count is zero, resource will not be locked and this resource
  # will not be created
  count = var.rg_lock_level == null ? 0 : 1

  lock_level = var.rg_lock_level
  name       = "rg-managment-lock-${module.azurerm_resource_group_label.id}"
  notes      = "Resource Group '${azurerm_resource_group.resource_group.name}' is locked with '${var.rg_lock_level}' level."
  scope      = azurerm_resource_group.resource_group.id
}