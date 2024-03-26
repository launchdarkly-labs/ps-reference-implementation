
output "project-roles" {
  description = "Project-level administration roles"
    value = {
        "admin" = launchdarkly_custom_role.workspace-admin
        "maintainer" = launchdarkly_custom_role.workspace-maintainer
    }
}

resource launchdarkly_custom_role "workspace-admin" {
  key              =  "admin-${local.project.key}"
  name             = "Project Admin - ${local.project.name}"
  description      = "All actions relating to projects/environments including potentially destructive ones such as delete project"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}:env/*:destination/*"]
    actions   = ["createDestination", "deleteDestination", "updateConfiguration", "updateName", "updateOn"]

  }

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}:env/*"]
    actions   = ["createEnvironment", "deleteEnvironment", "updateApiKey", "updateApprovalSettings", "updateColor", "updateConfirmChanges", "updateDefaultTrackEvents", "updateMobileKey", "updateName", "updateRequireComments", "updateSecureMode", "updateTags", "updateTtl"]

  }

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}:env/*:flag/*"]
    actions   = ["deleteFlag", "updateFlagSalt"]

  }

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}:env/*:user/*"]
    actions   = ["deleteUser"]

  }

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}"]
    actions   = ["createProject", "deleteProject", "updateDefaultClientSideAvailability", "updateProjectName", "updateTags"]

  }

}

resource launchdarkly_custom_role "workspace-maintainer" {
  key              = "maintainer-${local.project.key}"
  name             = "Project Maintainer - ${local.project.name}"
  description      = "Allow any project/environment actions that do not impact the evaluation of existing flags. Can’t delete destinations"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}:env/*:destination/*"]
    actions   = ["createDestination", "updateConfiguration", "updateName", "updateOn"]

  }

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}:env/*"]
    actions   = ["createEnvironment", "updateColor", "updateDefaultTrackEvents", "updateName", "updateRequireComments", "updateTags", "updateTtl"]

  }

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}:env/*:user/*"]
    actions   = ["deleteUser"]

  }

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}"]
    actions   = ["createProject", "updateDefaultClientSideAvailability", "updateIncludeInSnippetByDefault", "updateProjectName", "updateTags"]

  }
}

