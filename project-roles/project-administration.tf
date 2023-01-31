
resource launchdarkly_custom_role "workspace-admin" {
  key              =  "admin-${var.project.key}"
  name             = "Project Admin - ${var.project.name}"
  description      = "All actions relating to projects/environments including potentially destructive ones such as delete project"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:destination/*"]
    actions   = ["createDestination", "deleteDestination", "updateConfiguration", "updateName", "updateOn"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*"]
    actions   = ["createEnvironment", "deleteEnvironment", "updateApiKey", "updateApprovalSettings", "updateColor", "updateConfirmChanges", "updateDefaultTrackEvents", "updateMobileKey", "updateName", "updateRequireComments", "updateSecureMode", "updateTags", "updateTtl"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:flag/*"]
    actions   = ["deleteFlag", "updateFlagSalt"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:user/*"]
    actions   = ["deleteUser"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}"]
    actions   = ["createProject", "deleteProject", "updateDefaultClientSideAvailability", "updateProjectName", "updateTags"]

  }


}


resource launchdarkly_custom_role "workspace-maintainer" {
  key              = "maintainer-${var.project.key}"
  name             = "Project Maintainer - ${var.project.name}"
  description      = "Allow any project/environment actions that do not impact the evaluation of existing flags. Can’t delete destinations"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:destination/*"]
    actions   = ["createDestination", "updateConfiguration", "updateName", "updateOn"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*"]
    actions   = ["createEnvironment", "updateColor", "updateDefaultTrackEvents", "updateName", "updateRequireComments", "updateTags", "updateTtl"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:user/*"]
    actions   = ["deleteUser"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}"]
    actions   = ["createProject", "updateDefaultClientSideAvailability", "updateIncludeInSnippetByDefault", "updateProjectName", "updateTags"]

  }
}

