output "environment-roles" {
  description = "Map of environment keys to a map of role keys to role values"
  value = {
    for env_key, env in local.environments: env_key => {
        "member" = launchdarkly_custom_role.member[env_key],
        "sdk-key" = launchdarkly_custom_role.sdk-key[env_key],
        "release-manager" = launchdarkly_custom_role.release-manager[env_key],
        "flag-manager" = launchdarkly_custom_role.flag-manager[env_key],
        "approver" = launchdarkly_custom_role.approver[env_key],
        "flag archiver" = launchdarkly_custom_role.flag-archiver[env_key],
        "segment-manager" = launchdarkly_custom_role.segment-manager[env_key],
        "apply-changes" = launchdarkly_custom_role.apply-changes[env_key],
        "variation-manager" = launchdarkly_custom_role.variation-manager[env_key]
    }
  }
}
resource "launchdarkly_custom_role" "member" {
  for_each         = local.environments
  key              = "member-${local.project.key}-${each.key}"
  name             = "Member - ${local.project.name} - ${each.value.name}"
  description      = "Can view the project and its flags, but cannot make changes"
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}"]
    actions   = ["viewProject", "createApprovalRequest"]
  }
  dynamic "policy_statements" {
    for_each = local.denied_environments[each.key]
    content {
      effect    = "deny"
      resources = ["proj/${local.project.specifier}:env/${policy_statements.value.specifier}:flag/*"]
      actions   = ["*"]
    }
  }
}
  
resource "launchdarkly_custom_role" "sdk-key" {
  for_each         = local.environments
  key              = "sdk-${local.project.key}-${each.key}"
  name             = "View SDK Key - ${local.project.name} - ${each.value.name}"
  description      = "Can view the read-only server-side SDK key in a single environment"
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/${each.value.specifier}"]
    actions   = ["viewSdkKey"]
  }
  dynamic "policy_statements" {
    for_each = local.denied_environments[each.key]
    content {
      effect    = "deny"
      resources = ["proj/${local.project.specifier}:env/${policy_statements.value.specifier}:flag/*"]
      actions   = ["*"]
    }
  }
}

resource "launchdarkly_custom_role" "flag-manager" {
  for_each         = local.environments
  key              = "flag-manager-${local.project.key}-${each.key}"
  name             = "Flag Manager - ${local.project.name} - ${each.value.name}"
  description      = "May perform flag management actions that do not impact the evaluation of existing flags"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/${each.value.specifier}:flag/*"]
    actions = [
      "cloneFlag", 
      "createFlag", 
      "createFlagLink", 
      "deleteFlagLink", 
      "updateDescription", 
      "updateFlagCustomProperties", 
      "updateFlagDefaultVariations", 
      "updateFlagLink", 
      "updateMaintainer", 
      "updateName", 
      "updateTags", 
      "updateTemporary"
    ]
  }
  dynamic "policy_statements" {
    for_each = local.denied_environments[each.key]
    content {
      effect    = "deny"
      resources = ["proj/${local.project.specifier}:env/${policy_statements.value.specifier}:flag/*"]
      actions   = ["*"]
    }
  }
}

resource "launchdarkly_custom_role" "approver" {
  for_each         = local.environments
  key              = "approver-${local.project.key}-${each.key}"
  name             = "Approver - ${local.project.name} - ${each.value.name}"
  description      = "May perform flag management actions that do not impact the evaluation of existing flags"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/${each.value.specifier}:flag/*"]
    actions = ["deleteApprovalRequest", "reviewApprovalRequest", "updateApprovalRequest"]
  }
  dynamic "policy_statements" {
    for_each = local.denied_environments[each.key]
    content {
      effect    = "deny"
      resources = ["proj/${local.project.specifier}:env/${policy_statements.value.specifier}:flag/*"]
      actions   = ["*"]
    }
  }
}
  
resource "launchdarkly_custom_role" "flag archiver" {
  for_each         = local.environments
  key              = "flag-archiver-${local.project.key}-${each.key}"
  name             = "Flag Archiver - ${local.project.name} - ${each.value.name}"
  description      = "May archive flags but not delete them. This action impacts the evaluation of existing flags in all environments. It can, however, be easily undone"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/${each.value.specifier}:flag/*"]
    actions = ["updateGlobalArchived"]
  }
  dynamic "policy_statements" {
    for_each = local.denied_environments[each.key]
    content {
      effect    = "deny"
      resources = ["proj/${local.project.specifier}:env/${policy_statements.value.specifier}:flag/*"]
      actions   = ["*"]
    }
  }
}
  
resource "launchdarkly_custom_role" "release-manager" {
  for_each         = local.environments
  key              = "release-manager-${local.project.key}-${each.key}"
  name             = "Release Manager - ${local.project.name} - ${each.value.name}"
  description      = "Allow actions on flags  that impact evaluation of flags in a single environment"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/${each.value.specifier}:flag/*"]
    actions = [
      "copyFlagConfigFrom",
      "copyFlagConfigTo",
      "createApprovalRequest",
      "updateExpiringRules",
      "updateExpiringTargets",
      "updateFallthrough",
      "updateFeatureWorkflows",
      "updateOffVariation",
      "updateOn",
      "updatePrerequisites",
      "updateRules",
      "updateScheduledChanges",
      "updateTargets"
    ]
  }
  dynamic "policy_statements" {
    for_each = local.denied_environments[each.key]
    content {
      effect    = "deny"
      resources = ["proj/${local.project.specifier}:env/${policy_statements.value.specifier}:flag/*"]
      actions   = ["*"]
    }
  }
}

resource "launchdarkly_custom_role" "approver" {
  for_each         = local.environments
  key              = "approver-${local.project.key}-${each.key}"
  name             = "Approver - ${local.project.name} - ${each.value.name}"
  description      = "Can review, update, and delete approval requests.Can not apply approval requests."
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${each.key}:env/*:flag/*"]
    actions   = ["deleteApprovalRequest", "reviewApprovalRequest", "updateApprovalRequest"]

  }
  dynamic "policy_statements" {
    for_each = local.denied_environments[each.key]
    content {
      effect    = "deny"
      resources = ["proj/${local.project.specifier}:env/${policy_statements.value.specifier}:flag/*"]
      actions   = ["*"]
    }
  }
}


resource "launchdarkly_custom_role" "segment-manager" {
  for_each         = local.environments
  key              = "segmgr-${local.project.key}-${each.key}"
  name             = " Segment Manager - ${local.project.name} - ${each.value.name}"
  description      = "Can create/modify/delete segments in a single environment"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/${each.value.specifier}:segment/*"]
    actions = [
      "createSegment",
      "deleteSegment",
      "updateDescription",
      "updateExcluded",
      "updateExpiringRules",
      "updateExpiringTargets",
      "updateIncluded",
      "updateName",
      "updateRules",
      "updateScheduledChanges",
      "updateTags"
    ]

  }
  dynamic "policy_statements" {
    for_each = local.denied_environments[each.key]
    content {
      effect    = "deny"
      resources = ["proj/${local.project.specifier}:env/${policy_statements.value.specifier}:flag/*"]
      actions   = ["*"]
    }
  }
}

resource "launchdarkly_custom_role" "apply-changes" {
  for_each         = local.environments
  key              = "applier-${local.project.key}-${each.key}"
  name             = "Applier - ${local.project.name} - ${each.value.name}"
  description      = "Can apply approved changes in production"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/${each.value.specifier}:flag/*"]
    actions   = ["applyApprovalRequest"]
  }
  dynamic "policy_statements" {
    for_each = local.denied_environments[each.key]
    content {
      effect    = "deny"
      resources = ["proj/${local.project.specifier}:env/${policy_statements.value.specifier}:flag/*"]
      actions   = ["*"]
    }
  }
}



resource "launchdarkly_custom_role" "variation-manager" {
  for_each         = local.environments
  key              = "variation-mgr-${local.project.key}-${each.key}"
  name             = "Variation Manager - ${local.project.name} - ${each.value.name}"
  description      = "Impacts evaluation of existing flags in all environments"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/${each.value.specifier}:flag/*"]
    actions   = ["updateFlagVariations"]
  }
  dynamic "policy_statements" {
    for_each = local.denied_environments[each.key]
    content {
      effect    = "deny"
      resources = ["proj/${local.project.specifier}:env/${policy_statements.value.specifier}:flag/*"]
      actions   = ["*"]
    }
  }
}





