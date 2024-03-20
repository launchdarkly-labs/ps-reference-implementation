

variable "name" {
    type = string 
    description = "Suffix appended to role names, normally set to the project name. Defaults to title(key)"
    default = null
}


variable "key" {
    type = string
    description = "Suffix appended to role keys, if null, will be set to the name_suffix in kebab-case"
    nullable = false
    validation {
      /* must be a valid launchdarkly resource specifier component */
        condition = regex("^[a-zA-Z0-9-_]+$", var.key)
        error_message = "key must contain only alphanumeric characters, hyphens, and underscores"
    }
}

variable "include_projects" {
    type = set(string)
    description = "Specifier(s) used to target projects and project sub-resources. Can be `project-key`, `*;tag,tag`, `project-key-prefix-*`, etc"
    nullable = false
    validation {
    /* must not be empty */
        condition = length(var.include_projects) > 0
        error_message = "include_projects must not be empty. Use [`*`] to include all projects"
    }
    validation {
      /* must be a valid launchdarkly resource specifier component */
        condition = alltrue([for p in var.include_projects: can(regex("^[a-zA-Z0-9-_*]+(?:;(?:[{}: a-zA-Z0-9-_*]+,?)+)?$", p))])
        error_message = "include_projects must be list of valid launchdarkly resource specifier (examples: `*`, `my-project-key`, `*;tag1,tag2`)"
    }
}

variable "exclude_projects" {
    type = set(string)
    description = "Specifier(s) used to exclude projects and project sub-resources. Can be `project-key`, `*;tag,tag`, `project-key-prefix-*`, etc"
    default = set()
    validation {
      /* must be a valid launchdarkly resource specifier component */
        condition = alltrue([for p in var.exclude_projects: can(regex("^[a-zA-Z0-9-_*]+(?:;(?:[{}: a-zA-Z0-9-_*]+,?)+)?$", p))])
        error_message = "exclude_projects must be list of valid launchdarkly resource specifier (examples: `*`, `my-project-key`, `*;tag1,tag2``)"
    }
}

variable "seperate_update_flag_variations_role" {
    type = bool
    description = "Whether to generate a seperate update_flag_variations role. If false, update flags role will have updateFlagVariations permission"
    default = false
}
variable "seperate_manage_contexts_role" {
    type = bool
    description = "Whether to generate a role for managing contexts. If false, update flags will have createContextKind, deleteContextKind, and updateContextKind permissions"
    default = false
}

variable "environment_role_groups" {
    type = map(object({
        name = string
        includes = set(string)
        excludes = optional(set(string), set())
    }))

  default = {
    "non-critical" = {
      includes = ["*;{critical:false}"]
      name = "noncritical"
    }
    "critical" = {
      includes = ["*;{critical:true}"]
      name = "Critical"
    }
  }
}



variable "viewers_can_request_changes" {
    type = bool
    description = "When true, `createApprovalRequest` will be included in the view project role"
    default = true
}


locals {
    // var.name or title-cased var.key with _ , .and - replaced with spaces 
   name = coalesce(var.name, title(replace(var.key, "/[_.-]+/", " ")))
   include_project_specifiers = toset([for p in var.include_projects: "proj/${p}"])
   exclude_project_specifiers = toset([for p in var.exclude_projects: "proj/${p}"])
}