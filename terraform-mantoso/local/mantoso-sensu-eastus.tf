# Locals and module prefix = mantoso_nagios_eastus
# Appllicaiton name = nagios

locals {
  mantoso_nagios_eastus_application_name              = "sensu"
  mantoso_nagios_eastus_location                      = "eastus"
  mantoso_nagios_eastus_rg_lock_level                 = null                                            # null, CanNotDelete or ReadOnly
  mantoso_nagios_eastus_subnet_address_prefix_public  = ["10.0.1.0/28", "10.0.1.16/28", "10.0.1.32/28"] # 10.0.1.48/28
  mantoso_nagios_eastus_virtual_network_address_space = "10.0.1.0/26"
}

module "mantoso_nagios_eastus_resource_group" {
  source = "../../modules/azurerm-resource-group"

  location      = local.mantoso_nagios_eastus_location
  rg_lock_level = local.mantoso_nagios_eastus_rg_lock_level
  name          = local.mantoso_nagios_eastus_application_name
  namespace     = var.namespace
  stage         = var.stage
}


module "mantoso_nagios_eastus_virtual_network" {
  source = "../../modules/azurerm-virtual-network"

  address_space       = local.mantoso_nagios_eastus_virtual_network_address_space
  location            = module.mantoso_nagios_eastus_resource_group.location
  name                = local.mantoso_nagios_eastus_application_name
  namespace           = var.namespace
  resource_group_name = module.mantoso_nagios_eastus_resource_group.name
  stage               = var.stage
}


module "mantoso_nagios_eastus_subnet_public" {
  source = "../../modules/azurerm-subnet"

  address_prefix       = local.mantoso_nagios_eastus_subnet_address_prefix_public
  name                 = local.mantoso_nagios_eastus_application_name
  namespace            = var.namespace
  resource_group_name  = module.mantoso_nagios_eastus_resource_group.name
  stage                = var.stage
  virtual_network_name = module.mantoso_nagios_eastus_virtual_network.name
}
