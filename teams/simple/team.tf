resource launchdarkly_team team {
    name = var.name
    key = var.key 
    description = var.description
    custom_role_keys = setsubtract(setunion(
        local.project-role-keys,
        local.environment-role-keys,
        toset(var.additional_role_keys)
    ), var.exclude_roles_keys)
    maintainers = var.maintainer_ids
    // we will ignore member ids so that they can be managed outside of terraform
    lifecycle {
        ignore_changes = [
            member_ids
        ]
    }
}

locals {
    project-role-keys = toset([ for k in var.project-roles: var.role-definitions.project-roles[k].key ])
    environment-role-keys = toset(flatten([ for env_key,roles in var.environment-roles: [for role in roles: var.role-definitions.environment-roles[env_key][role].key]]))

}