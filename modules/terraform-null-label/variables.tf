variable account {
  default     = ""
  description = "Account, could be infosec, billing or something that is not a stage."
  type        = string
}

variable additional_tag_map {
  default     = {}
  description = "Additional tags for appending to each tag map"
  type        = map(string)
}

variable attributes {
  default     = []
  description = "Additional attributes (e.g. `1`)"
  type        = list(string)
}

variable context {
  default = {
    namespace           = ""
    location            = ""
    account             = ""
    stage               = ""
    name                = ""
    enabled             = true
    delimiter           = ""
    attributes          = []
    label_order         = []
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = ""
  }
  description = "Default context to use for passing state between label invocations"
  type = object({
    namespace           = string
    location            = string
    account             = string
    stage               = string
    name                = string
    enabled             = bool
    delimiter           = string
    attributes          = list(string)
    label_order         = list(string)
    tags                = map(string)
    additional_tag_map  = map(string)
    regex_replace_chars = string
  })
}

variable delimiter {
  default     = "-"
  description = "Delimiter to be used between `namespace`, `account`, `stage`, `name` ,`location` and `attributes`"
  type        = string
}

variable label_order {
  default     = []
  description = "The naming order of the id output and Name tag"
  type        = list(string)
}

variable location {
  default     = ""
  description = "Location of resource"
  type        = string
}

variable enabled {
  default     = true
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
}

variable name {
  default     = ""
  description = "Solution or application name, e.g. 'app' or 'jenkins'"
  type        = string
}

variable namespace {
  default     = ""
  description = "Namespace, could be your organization name or an abbreviation."
  type        = string
}

variable regex_replace_chars {
  default     = "/[^a-zA-Z0-9-]/"
  description = "Regex to replace chars with empty string in `namespace`, `account`, `stage`, `name` and `location`. By default only hyphens, letters and digits are allowed, all other chars are removed"
  type        = string
}

variable stage {
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  type        = string
}

variable tags {
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
  type        = map(string)
}
