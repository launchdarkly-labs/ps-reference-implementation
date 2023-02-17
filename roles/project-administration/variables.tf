variable "project" {
    type = object({
        name = string
        key  = string
    })
    description = "LaunchDarkly project. The key will be used to generate role keys. If you are using wildcards, use the project_specifier variable"
}

variable "project_specifier" {
    type = string
    description = "Value used to select the project. If null, the project key will be used"
    default = null
}

variable "environments" {
    type = map(object({
        name = string
    }))

  default = {
    "test" = {
      name = "Test"
    }
    "production" = {
      name = "Production"
    }
  }
}

variable environment_specifiers {
    type = map(string)
    description = "Map of environment keys to environment specifiers. Defaults to the environment key"
    default = {}
}

variable "environment_excludes" {
    type = map(list(string))
    description = "Map of environment keys to a list of environments to generate deny statements for when creating environment-levle roles"
    default = {}
}

locals {
    
    project = {
        key = var.project.key
        name = var.project.name
        specifier = var.project_specifier == null ?  var.project.key : var.project_specifier
    }

    environments = {
        for key,value in var.environments: key => {
            name = value.name
            specifier = try(var.environment_specifiers[key], key)
        }
    }
    denied_environments = {
        for k,v in local.environments : k => [for exclude in try(var.environment_excludes[k], []): local.environments[exclude]]
    }
}