
/// Read only access to a subset of projects
/// May create approval requests.
/// Rationale: Empower any team to request changes to the application. May be scoped with a tag. Think requesting user impersonation
resource launchdarkly_custom_role "view-project" {
  key              = "view-${var.project.key}"
  name             = "View - ${var.project.name}"
  description      = "Can view the project and its flags, but cannot make changes."
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}"]
    actions   = ["viewProject", "createApprovalRequest"]
  }
}

resource launchdarkly_custom_role "sdk-key" {
  for_each         = var.environments
  key              = "sdk-${var.project.key}-${each.key}"
  name             = "View SDK Key - ${var.project.name} - ${each.value.name}"
  description      = "Can view the read-only server-side SDK key in a single environment"
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/${each.key}"]
    actions   = ["viewSdkKey"]
  }
}

resource launchdarkly_custom_role "flag-manager" {
  key              = "flag-manager-${var.project.key}"
  name             = "Flag Manager - ${var.project.name}"
  description      = "May perform flag management actions that do not impact the evaluation of existing flags."
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:flag/*"]
    actions   = ["cloneFlag", "createFlag", "createFlagLink", "deleteFlagLink", "updateDescription", "updateFlagCustomProperties", "updateFlagDefaultVariations", "updateFlagLink", "updateMaintainer", "updateName", "updateTags", "updateTemporary"]

  }
}



resource launchdarkly_custom_role "release-manager" {
  for_each         = var.environments
  key              = "release-manager-${var.project.key}-${each.key}"
  name             = "Release Manager - ${var.project.name} - ${each.value.name}"
  description      = "Allow actions on flags  that impact evaluation of flags in a single environment"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/${each.key}:flag/*"]
    actions   = ["copyFlagConfigFrom", "copyFlagConfigTo", "createApprovalRequest", "updateExpiringRules", "updateExpiringTargets", "updateFallthrough", "updateFeatureWorkflows", "updateOffVariation", "updateOn", "updatePrerequisites", "updateRules", "updateScheduledChanges", "updateTargets"]

  }
}

resource launchdarkly_custom_role "approver" {
  for_each         = var.environments
  key              = "approver-${var.project.key}-${each.key}"
  name             = "Approver - ${var.project.name} - ${each.value.name}"
  description      = "Can review, update, and delete approval requests.Can not apply approval requests."
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${each.key}:env/*:flag/*"]
    actions   = ["deleteApprovalRequest", "reviewApprovalRequest", "updateApprovalRequest"]

  }
}



resource launchdarkly_custom_role "segment-manager" {
  for_each         = var.environments
  key              = "segmgr-${var.project.key}-${each.key}"
  name             = " Segment Manager - ${var.project.name} - ${each.value.name}"
  description      = "Can create/modify/delete segments in a single environment"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/${each.key}:segment/*"]
    actions   = ["createSegment", "deleteSegment", "updateDescription", "updateExcluded", "updateExpiringRules", "updateExpiringTargets", "updateIncluded", "updateName", "updateRules", "updateScheduledChanges", "updateTags"]

  }
}


resource launchdarkly_custom_role "apply-changes" {
  for_each         = var.environments
  key              = "applier-${var.project.key}-${each.key}"
  name             = "Applier - ${var.project.name} - ${each.value.name}"
  description      = "Can apply approved changes in production"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/${each.key}:flag/*"]
    actions   = ["applyApprovalRequest"]
  }
}



resource launchdarkly_custom_role "flag-archiver" {
  key              = "archiver-${var.project.key}"
  name             = "Archiver - ${var.project.name}"
  description      = "May archive flags but not delete them. This action impacts the evaluation of existing flags in all environments. It can, however, be easily undone."
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:flag/*"]
    actions   = ["updateGlobalArchived"]
  }
}

resource launchdarkly_custom_role "variation-manager" {
  key              = "varmgr-${var.project.key}"
  name             = "Variation Manager - ${var.project.key}"
  description      = "Impacts evaluation of existing flags in all environments"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:flag/*"]
    actions   = ["updateFlagVariations"]
  }
}


resource launchdarkly_custom_role "sdk-manager" {
  key              = "sdk-mgr-${var.project.key}"
  name             = "SDK Manager - ${var.project.key}"
  description      = "Impacts the evaluation of flags in all environments for client-side SDKs"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:flag/*"]
    actions   = ["updateClientSideFlagAvailability"]

  }
}



resource launchdarkly_custom_role "trigger-manager" {
  for_each         = var.environments
  key              = "trigger-mgr-${var.project.key}-${each.key}"
  name             = "Trigger Manager - ${var.project.name} - ${each.value.name}"
  description      = "Delegates authority to toggle a flag on/off via unguessable URL endpoint"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/${each.key}:flag/*"]
    actions   = ["updateTriggers"]
  }
}

