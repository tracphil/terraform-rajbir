# Only put variables here that are applicable accross the whole environment

# Defined as environment variables
variable "local_client_id" {
  description = "Azure Client Secret"
}

variable "local_client_secret" {
  description = "Azure Client Secret"
}

variable "local_subscription_id" {
  description = "Azure Subscription ID"
}

variable "local_tenant_id" {
  description = "Azure Tenant ID"
}

variable "stage" {
  description = "Azure Subscription name"
}

variable "namespace" {
  description = "Namespace for resource"
}
