output "environment-roles" {
  description = "Map of environment keys to a map of role keys to role values"
  value = {
    for env_key, env in local.environments: env_key => {
        "sdk-key" = launchdarkly_custom_role.sdk-key[env_key],
        "release-manager" = launchdarkly_custom_role.release-manager[env_key],
        "approver" = launchdarkly_custom_role.approver[env_key],
        "segment-manager" = launchdarkly_custom_role.segment-manager[env_key],
        "apply-changes" = launchdarkly_custom_role.apply-changes[env_key],
        "trigger-manager" = launchdarkly_custom_role.trigger-manager[env_key]
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
  description      = "Can apply approved changes in ${each.value.name}"
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



resource "launchdarkly_custom_role" "trigger-manager" {
  for_each         = local.environments
  key              = "trigger-mgr-${local.project.key}-${each.key}"
  name             = "Trigger Manager - ${local.project.name} - ${each.value.name}"
  description      = "Delegates authority to toggle a flag on/off via unguessable URL endpoint"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/${each.value.specifier}:flag/*"]
    actions   = ["updateTriggers"]
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





