
launchdarkly_custom_role "workspace-admin" {
  key              =  "${var.project.key}-admin"
  name             = "${var.project.name} Admin"
  description      = "All actions relating to projects/environments including potentially destructive ones such as delete project"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:destination/*"]
    actions   = ["createDestination", "deleteDestination", "updateConfiguration", "updateName", "updateOn"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.name}:env/*"]
    actions   = ["createEnvironment", "deleteEnvironment", "updateApiKey", "updateApprovalSettings", "updateColor", "updateConfirmChanges", "updateDefaultTrackEvents", "updateMobileKey", "updateName", "updateRequireComments", "updateSecureMode", "updateTags", "updateTtl"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.name}:env/*:flag/*"]
    actions   = ["deleteFlag", "updateFlagSalt"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.name}:env/*:user/*"]
    actions   = ["deleteUser"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.name}"]
    actions   = ["createProject", "deleteProject", "updateDefaultClientSideAvailability", "updateProjectName", "updateTags"]

  }


}


launchdarkly_custom_role "workspace-maintainer" {
  key              = "${var.project.name}-maintainer"
  name             = ": ${var.project.name}"
  description      = "Allow any project/environment actions that do not impact the evaluation of existing flags. Can’t delete destinations"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.name}:env/*:destination/*"]
    actions   = ["createDestination", "updateConfiguration", "updateName", "updateOn"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.name}:env/*"]
    actions   = ["createEnvironment", "updateColor", "updateDefaultTrackEvents", "updateName", "updateRequireComments", "updateTags", "updateTtl"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.name}:env/*:user/*"]
    actions   = ["deleteUser"]

  }


  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.name}"]
    actions   = ["createProject", "updateDefaultClientSideAvailability", "updateIncludeInSnippetByDefault", "updateProjectName", "updateTags"]

  }
}

