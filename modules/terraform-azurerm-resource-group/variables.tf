
variable namespace {
  description = "Namespace for resource"
  type        = string
}

variable stage {
  description = "Stage (e.g. prod or uat)"
  type        = string
}

variable name {
  description = "Application Name"
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
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable location {
  description = "The location where the resource should be created."
  type        = string
}

variable rg_lock_level {
  description = "Management Lock (e.g. CanNotDelete or ReadOnly) for resource group"
  type        = string
  default     = null
}