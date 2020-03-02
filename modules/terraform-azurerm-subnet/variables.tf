
variable namespace {
  description = "Namespace the for resource"
  type        = string
}

variable stage {
  description = "Stage (e.g. prod or uat)"
  type        = string
}

variable name {
  description = "Name (e.g. app or cluster)"
  type        = string
}

variable delimiter {
  description = "Character to be used between labels"
  type        = string
  default     = "-"
}

variable attributes {
  description = "Additional attributes (e.g. 01)"
  type        = list(string)
  default     = []
}

variable tags {
  description = "Additional tags (e.g. map('Application', 'Canned Soup') )"
  type        = map(string)
  default     = {}
}

variable address_prefix {
  description = "The CIDR for use for the Virtual Network."
  type        = list(string)
}

variable resource_group_name {
  description = "The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
  type        = string
}

variable virtual_network_name {
  description = "The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
  type        = string
}
