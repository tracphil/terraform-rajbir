/*
 * Module: terraform-azure-backend
 * Bootstrap your terraform backend on Azure
 *
 * This template creates and/or manages the following resources
 * - A Resource Group
 * - Storage Acccount
 *
*/

module "mantoso_nagios_eastus_resource_group" {
  source = "http://github.com/mantoso/terraform-azurerm-resource-group"

  location      = var.location
  rg_lock_level = var.rg_lock_level
  name          = var.name
  namespace     = var.namespace
  account       = var.account
}

resource "azurerm_storage_account" "storage_account" {
  # Name can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long
  name                      = "kylerstorageaccount"  # This is the storage_account_name value in the terraform backend block above
  resource_group_name       = azurerm_resource_group.resource_group.name
  location                  = azurerm_resource_group.resource_group.location
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "storage_container" {
  # Name must be lower-case characters or numbers only. No hyphens, underscores, or caps.
  name                 = "terraform-state-container"  ## This is the container_name value in the terraform backend block above above
  storage_account_name = azurerm_storage_account.storage_account.name
}

