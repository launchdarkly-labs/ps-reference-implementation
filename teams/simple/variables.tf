variable key {
    description = "LaunchDarkly Team key"
    type = string
}
variable name {
  description = "LaunchDarkly Team name"
    type = string
}

variable description {
    description = "LaunchDarkly Team description"
    type = string
}

variable maintainer_ids {
    description = "List of LaunchDarkly member IDs to add as maintainers"
    type = set(string)
}

variable role-definitions {
    description = "Inventory of role definitions from the roles module"
    type = object({
            project-roles = map(
                object({
                    key = string
                })
            ),
        environment-roles = map(map(
            object({
            key = string
            })
        ))
    })
    
    default = {
        project-roles = {},
        environment-roles = {}
    }
}

variable project-roles {
    description = "Set of project role keys as defined in the role definitions object"
    type = set(string)
    default = ["view-project"]
}

variable environment-roles {
    description = "Map of environments to environment role keys as defined in the role definitions object"
    type = map(set(string))
}


variable additional_role_keys {
    description = "List of additional role keys to add to this team"
    type = set(string)
    default = []
}

variable exclude_roles_keys {
    description = "List of role keys to exclude from this team"
    type = set(string)
    default = []
}