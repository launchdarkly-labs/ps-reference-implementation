locals {
    allow_tag = "allow-${local.key}"
    proj = "proj/*;allow-${local.key}"
    extraFlagActions = {
      frontend = ["updateClientSideFlagAvailability", "updateIncludeInSnippet"],
      backend = [],
      dba = []
    }
    flagMgmtActions = [ 
      "createFlag",
      "cloneFlag",
      "updateName",
      "updateDescription",
      "updateFlagCustomProperties",
      "updateMaintainer",
      "updateFlagDefaultVariations"
    ]

    flagRuleActions =  [     "updateOn",
      "updatePrerequisites",
      "updateTriggers",
      "updateTargets",
      "updateRules",
      "updateFlagRuleDescription",
      "updateFallthrough",
      "updateOffVariation",
      "updateExpiringRules",
      "updateExpiringTargets",
      "copyFlagConfigFrom",
      "copyFlagConfigTo",
      "updateFeatureWorkflows",
      "updateScheduledChanges",
      "applyApprovalRequest",
      "reviewApprovalRequest",
      "updateApprovalRequest",
      "deleteApprovalRequest"
      
      ]
}

resource "launchdarkly_custom_role" "guest" {
  key         = "guest-${local.key}"
  name         = "${local.key}: guest"

  description = "Workshop guest access for ${local.key}"

policy_statements {
    effect    = "deny"
    not_resources = [local.proj]
    actions   = ["viewProject"]
  }

  policy_statements {
    effect    = "allow"
    resources = [local.proj]
    actions   = ["viewProject"]
  }

  policy_statements {
    effect = "allow"
    resources = ["${local.proj}:env/*:flag/*"]
    actions = ["*"]
  } 
  
  policy_statements {
    effect = "allow"
    resources = ["${local.proj}:env/*:segment/*"]
    actions = ["*"]
  } 

  policy_statements {
        effect = "deny"
        resources =  ["${local.proj}:env/production:flag/*;managed-by-*"]
        actions = [
        "*"
      ]
  }
  policy_statements {
        effect = "deny"
        resources =  ["${local.proj}:env/production:segment/*;managed-by-*"]
        actions = [
        "*"
      ]
  }

}

resource "launchdarkly_custom_role" "team" {
  for_each = toset(["frontend", "backend", "dba"])
  key         = "team-${each.key}-${local.key}"
  name         = "${local.key}: ${each.key} team"

  description = "Workshop ${each.key} team for ${local.key}. Should be combined with ${launchdarkly_custom_role.guest.key}"

  policy_statements {
    effect    = "deny"
    not_resources = [local.proj]
    actions   = ["viewProject"]
  }
  

  policy_statements {
    effect    = "allow"
    resources = [local.proj]
    actions   = ["viewProject"]
  }

  policy_statements {
    effect = "allow"
    resources = ["${local.proj}:env/*:flag/*;managed-by-${each.key}"]
    actions = setunion(local.flagRuleActions, local.flagMgmtActions, local.extraFlagActions[each.key], ["updateGlobalArchived"])
  }
  policy_statements {
    effect = "allow"
    resources = ["${local.proj}:env/*:segment/*;managed-by-${each.key}"]
    actions = ["*"]
  }

 
policy_statements {
    effect = "allow"
    resources = ["${local.proj}:env/*:flag/*;managed-by-${each.key}"]
    actions = ["reviewApprovalRequest", "approveApprovalRequest", "applyApprovalRequest", "updateApprovalRequest", "deleteApprovalRequest"]
  }
}