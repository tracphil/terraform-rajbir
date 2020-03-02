# Terraform Module: azurerm_subnet

Manages a single or multiple subnets. Subnets represent network segments within the IP space defined by the virtual network.
## Usage

```hcl-terraform
locals {
  mantoso_confluence_eastus_application_name              = "confluence"
  mantoso_confluence_eastus_location                      = "eastus"
  mantoso_confluence_eastus_rg_lock_level                 = null                                            # null, CanNotDelete or ReadOnly
  mantoso_confluence_eastus_subnet_address_prefix_public  = ["10.0.1.0/28", "10.0.1.16/28", "10.0.1.32/28"] # 10.0.1.48/28
  mantoso_confluence_eastus_virtual_network_address_space = "10.0.1.0/26"
}

module "mantoso_confluence_eastus_resource_group" {
  source = "../../modules/azurerm-resource-group"

  location      = local.mantoso_confluence_eastus_location
  rg_lock_level = local.mantoso_confluence_eastus_rg_lock_level
  name          = local.mantoso_confluence_eastus_application_name
  namespace     = var.namespace
  stage         = var.stage
}


module "mantoso_confluence_eastus_virtual_network" {
  source = "../../modules/azurerm-virtual-network"

  address_space       = local.mantoso_confluence_eastus_virtual_network_address_space
  location            = module.mantoso_confluence_eastus_resource_group.location
  name                = local.mantoso_confluence_eastus_application_name
  namespace           = var.namespace
  resource_group_name = module.mantoso_confluence_eastus_resource_group.name
  stage               = var.stage
}


module "mantoso_confluence_eastus_subnet_public" {
  source = "../../modules/azurerm-subnet"

  address_prefix       = local.mantoso_confluence_eastus_subnet_address_prefix_public
  name                 = local.mantoso_confluence_eastus_application_name
  namespace            = var.namespace
  resource_group_name  = module.mantoso_confluence_eastus_resource_group.name
  stage                = var.stage
  virtual_network_name = module.mantoso_confluence_eastus_virtual_network.name
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| address\_prefix | The CIDR for use for the Virtual Network. | `list(string)` | n/a | yes |
| attributes | Additional attributes (e.g. 01) | `list(string)` | `[]` | no |
| delimiter | Character to be used between labels | `string` | `"-"` | no |
| name | Name (e.g. app or cluster) | `string` | n/a | yes |
| namespace | Namespace the for resource | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the subnet. Changing this forces a new resource to be created. | `string` | n/a | yes |
| stage | Stage (e.g. prod or uat) | `string` | n/a | yes |
| tags | Additional tags (e.g. map('Application', 'Canned Soup') ) | `map(string)` | `{}` | no |
| virtual\_network\_name | The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created. | `string` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
