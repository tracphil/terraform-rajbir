# Terraform Module: azurerm_resource_group

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| attributes | Additional attributes (e.g. 1) | `list(string)` | `[]` | no |
| delimiter | Character to be used between labels) | `string` | `"-"` | no |
| location | The location where the resource should be created. | `string` | n/a | yes |
| name | Application Name | `string` | n/a | yes |
| namespace | Namespace for resource | `string` | n/a | yes |
| rg\_lock\_level | Management Lock (e.g. CanNotDelete or ReadOnly) for resource group | `string` | n/a | yes |
| stage | Stage (e.g. prod or uat) | `string` | n/a | yes |
| tags | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | n/a |
| location | n/a |
| name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
