/// Read only access to a subset of projects
/// May create approval requests.
/// Rationale: Empower any team to request changes to the application. May be scoped with a tag. Think requesting user impersonation
launchdarkly_custom_role "project_member" {
  key              = "${var.project.key}-member"
  name             = "${var.project.name} Member"
  description      = "Can view the project and its flags, but cannot make changes."
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}"]
    actions   = ["viewProject", "createApprovalRequest"]
  }
}

launchdarkly_custom_role "sdk-key" {
  for_each         = var.environments
  key              = "${var.project.key}-sdk-key-${each.key}"
  name             = "${var.project.name} SDK Key: ${each.value.name}"
  description      = "Can view the read-only server-side SDK key in preproduction environments"
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}"]
    actions   = ["viewSdkKey"]
  }
}




launchdarkly_custom_role "flag-manager" {
  key              = "${var.project.key}-flag-manager"
  name             = "${var.project.name} Flag Manager"
  description      = "May perform flag management actions that do not impact the evaluation of existing flags."
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:flag/*"]
    actions   = ["cloneFlag", "createFlag", "createFlagLink", "deleteFlagLink", "updateDescription", "updateFlagCustomProperties", "updateFlagDefaultVariations", "updateFlagLink", "updateMaintainer", "updateName", "updateTags", "updateTemporary"]

  }
}



launchdarkly_custom_role "release-manager" {
  for_each         = var.environments
  key              = "${var.project.key}-release-manager-${each.key}"
  name             = "${var.project.name} Release Manager: ${each.value.name}"
  description      = "Allow actions on flags  that impact evaluation of flags in a single environment"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/${each.value.key}:flag/*"]
    actions   = ["copyFlagConfigFrom", "copyFlagConfigTo", "createApprovalRequest", "updateExpiringRules", "updateExpiringTargets", "updateFallthrough", "updateFeatureWorkflows", "updateOffVariation", "updateOn", "updatePrerequisites", "updateRules", "updateScheduledChanges", "updateTargets"]

  }
}

launchdarkly_custom_role "approver" {
  for_each         = var.environments
  key              = "${var.project.key}-approver-${each.key}"
  name             = "${var.project.name} Approver: ${each.value.name}"
  description      = "Can review, update, and delete approval requests.Can not apply approval requests."
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${each.value.key}:env/*:flag/*"]
    actions   = ["deleteApprovalRequest", "reviewApprovalRequest", "updateApprovalRequest"]

  }
}



launchdarkly_custom_role "segment-manager" {
  for_each         = var.environments
  key              = "${var.project.key}-segment-manager-${each.key}"
  name             = "${var.project.name} Segment Manager: ${each.value.name}"
  description      = "Can create/modify/delete segments in a single environment"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/${each.value.key}:segment/*"]
    actions   = ["createSegment", "deleteSegment", "updateDescription", "updateExcluded", "updateExpiringRules", "updateExpiringTargets", "updateIncluded", "updateName", "updateRules", "updateScheduledChanges", "updateTags"]

  }
}


launchdarkly_custom_role "apply-changes" {
  for_each         = var.environments
  key              = "${var.project.key}-apply-changes-${each.key}"
  name             = "${var.project.Name} Apply Changes: ${each.value.name}"
  description      = "Can apply approved changes in production"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/${each.value.key}:flag/*"]
    actions   = ["applyApprovalRequest"]
  }
}



launchdarkly_custom_role "flag-archiver" {
  key              = "${var.project.key}-archiver"
  name             = "${var.project.name} Archiver"
  description      = "May archive flags but not delete them. This action impacts the evaluation of existing flags in all environments. It can, however, be easily undone."
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:flag/*"]
    actions   = ["updateGlobalArchived"]
  }
}

launchdarkly_custom_role "variation-manager" {
  key              = "variation-manager-${var.project.key}"
  name             = "Variation Manager: ${var.project.key}"
  description      = "Impacts evaluation of existing flags in all environments"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:flag/*"]
    actions   = ["updateFlagVariations"]
  }
}


launchdarkly_custom_role "sdk-manager" {
  key              = "sdk-manager-${var.project.key}"
  name             = "SDK Manager: ${var.project.key}"
  description      = "Impacts the evaluation of flags in all environments for client-side SDKs"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:flag/*"]
    actions   = ["updateClientSideFlagAvailability"]

  }
}



launchdarkly_custom_role "trigger-manager" {
  for_each         = var.environments
  key              = "${var.project.key}-trigger-manager-${each.key}"
  name             = "${var.project.name} Trigger Manager - ${each.value.name}"
  description      = "Delegates authority to toggle a flag on/off via unguessable URL endpoint"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/${each.value.key}:flag/*"]
    actions   = ["updateTriggers"]
  }
}
