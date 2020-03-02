#
# Required Variables
#
variable namespace {
  description = "Namespace for resource"
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
  description = "Character to be used between labels)"
  type        = string
  default     = "-"
}

variable attributes {
  description = "Additional attributes (e.g. 1)"
  type        = list(string)
  default     = []
}

variable tags {
  description = "Additional tags (e.g. map('Application', 'Canned Soup') )"
  type        = map(string)
  default     = {}
}

variable address_space {
  description = "CIDR for vNet"
  type        = string
}

variable location {
  description = "The location where the resource should be created."
  type        = string
}

variable resource_group_name {
  description = ""
  type        = string
}
