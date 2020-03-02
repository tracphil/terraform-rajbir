terraform {
  required_version = ">=0.12"
  required_providers {
    azurerm = ">=1.41.0"
  }
}


provider "azurerm" {
  client_id       = var.local_client_id
  client_secret   = var.local_client_secret
  subscription_id = var.local_subscription_id
  tenant_id       = var.local_tenant_id
}
