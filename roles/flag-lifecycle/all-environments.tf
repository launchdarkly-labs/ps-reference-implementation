output "project-roles"{
    description = "Project-level flag lifecycle management roles"
    value = {
        "view-project" = launchdarkly_custom_role.view-project,
        "sdk-key" = launchdarkly_custom_role.sdk-key,
        "flag-manager" = launchdarkly_custom_role.flag-manager,
        "release-manager" = launchdarkly_custom_role.release-manager,
        "flag-archiver" = launchdarkly_custom_role.flag-archiver,
        "variation-manager" = launchdarkly_custom_role.variation-manager,
        "sdk-manager" = launchdarkly_custom_role.sdk-manager

    }
}

/// Read only access to a subset of projects
/// May create approval requests.
/// Rationale: Empower any team to request changes to the application. May be scoped with a tag. Think requesting user impersonation
resource launchdarkly_custom_role "view-project" {
  key              = "view-${local.project.key}"
  name             = "View - ${local.project.name}"
  description      = "Can view the project and its flags, but cannot make changes."
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}"]
    actions   = ["viewProject", "createApprovalRequest"]
  }
}

resource launchdarkly_custom_role "flag-manager" {
  key              = "flag-manager-${local.project.key}"
  name             = "Flag Manager - ${local.project.name}"
  description      = "May perform flag management actions that do not impact the evaluation of existing flags."
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/*:flag/*"]
    actions   = ["cloneFlag", "createFlag", "createFlagLink", "deleteFlagLink", "updateDescription", "updateFlagCustomProperties", "updateFlagDefaultVariations", "updateFlagLink", "updateMaintainer", "updateName", "updateTags", "updateTemporary"]

  }
}

resource launchdarkly_custom_role "flag-archiver" {
  key              = "archiver-${local.project.key}"
  name             = "Archiver - ${local.project.name}"
  description      = "May archive flags but not delete them. This action impacts the evaluation of existing flags in all environments. It can, however, be easily undone."
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/*:flag/*"]
    actions   = ["updateGlobalArchived"]
  }
}

resource launchdarkly_custom_role "variation-manager" {
  key              = "varmgr-${local.project.key}"
  name             = "Variation Manager - ${local.project.name}"
  description      = "Impacts evaluation of existing flags in all environments"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/*:flag/*"]
    actions   = ["updateFlagVariations"]
  }
}

resource launchdarkly_custom_role "sdk-manager" {
  key              = "sdk-mgr-${local.project.key}"
  name             = "SDK Manager - ${local.project.name}"
  description      = "Impacts the evaluation of flags in all environments for client-side SDKs"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/*:flag/*"]
    actions   = ["updateClientSideFlagAvailability"]

  }
}


