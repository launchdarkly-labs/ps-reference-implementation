variable "project" {
    type = object({
        name = string
        key  = string
    })
    description = "LaunchDarkly project"
    default = {
      key = "*"
      name = "All projects"
    }
  
}

variable "environments" {
    type = map(object({
        name = string
    }))

  default = {
    "*" = {
      name = "All environments"
    }
    "test" = {
      name = "Test"
    }
    "production" = {
      name = "Production"
    }
  }
}


locals {
    experiment-roles = {
        "experiment-manager" = launchdarkly_custom_role.experiment-manager
        "experiment-maintainer" = launchdarkly_custom_role.experiment-maintainer
    }
    project-roles = {
        "project-admin" = launchdarkly_custom_role.workspace-admin
        "project-maintainer" = launchdarkly_custom_role.workspace-maintainer
    }
    lifecycle-roles = {
    "view-project" = launchdarkly_custom_role.view-project
    "sdk-key" = launchdarkly_custom_role.sdk-key
    "flag-manager" = launchdarkly_custom_role.flag-manager
    "release-manager" = launchdarkly_custom_role.release-manager
    "approver" = launchdarkly_custom_role.approver
    "segment-manager" = launchdarkly_custom_role.segment-manager
    "apply-changes" = launchdarkly_custom_role.apply-changes
    "flag-archiver" = launchdarkly_custom_role.flag-archiver
    "variation-manager" = launchdarkly_custom_role.variation-manager
    "sdk-manager" = launchdarkly_custom_role.sdk-manager
    "trigger-manager" = launchdarkly_custom_role.trigger-manager
  }
}

output "lifecycle-roles" {
  description = "Map of LaunchDarkly custom role resource names to values"
  value = local.lifecycle-roles
}

output "by-environment" {
  description = "Map of LaunchDarkly custom role resource names to values"
  value = {
    for env in keys(var.environments): env => {
        for k,v in local.lifecycle-roles: k => v[env] if can(v[env]) }
  }
}