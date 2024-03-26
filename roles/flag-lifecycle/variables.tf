variable "project" {
    type = object({
        name = string
        key  = string
    })
    description = "LaunchDarkly project. The key will be used to generate role keys. If you are using wildcards, use the project_specifier variable"
}

variable "role_key" {
    type = string
    description = "Value appended to generated role keys. If null, project.key will be used"
    default = null
}

variable "with_separate_variation_manager" {
    type = bool
    description = "Whether to generate a role for  variation manager. If false, flag manager will have updateFlagVariations permission"
    default = false
}

variable "with_separate_context_manager" {
    type = bool
    description = "Whether to generate a role for context manager. If false, flag manager will have createContextKind, deleteContextKind, and updateContextKind permissions"
    default = false
}

variable "environments" {
    type = map(object({
        name = string
        key = string
    }))

  default = {
    "all" = {
      key = "*"
      name = "All environments"
    }
    "test" = {
      key = "test"
      name = "Test"
    }
    "production" = {
      key = "productionf"
      name = "Production"
    }
  }
}

variable "viewers_can_request_changes" {
    type = bool
    description = "When true, `createApprovalRequest` will be included in the view project role"
    default = true
}

variable "environment_excludes" {
    type = map(list(string))
    description = "Map of environment keys to a list of environments to generate deny statements for when creating environment-levle roles"
    default = {}
}

locals {
    project = {
        key = var.role_key != null ? var.role_key : var.project.key
        name = var.project.name
        specifier = var.project.key
    }

    environments = {
        for key,value in var.environments: key => {
            name = value.name
            specifier = value.key != null ? value.key : key
        }
    }
    denied_environments = {
        for k,v in local.environments : k => [for exclude in try(var.environment_excludes[k], []): local.environments[exclude]]
    }
}
