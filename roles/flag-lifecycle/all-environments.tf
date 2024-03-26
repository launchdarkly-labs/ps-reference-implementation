output "project-roles"{
    description = "Project-level flag lifecycle management roles"
    value = merge(
    {
        "view-project" = launchdarkly_custom_role.view-project,
        "flag-manager" = launchdarkly_custom_role.flag-manager,
        "flag-archiver" = launchdarkly_custom_role.flag-archiver,
        "sdk-manager" = launchdarkly_custom_role.sdk-manager,
        # "approver" = launchdarkly_custom_role.approver-all
        # "apply-changes" = launchdarkly_custom_role.apply-changes-all
    }, var.with_separate_variation_manager ? {
        "variation-manager" = launchdarkly_custom_role.variation-manager[0]
    } : {})
}

/// Read only access to a subset of projects
/// May create approval requests.
/// Rationale: Empower any team to request changes to the application. May be scoped with a tag. Think requesting user impersonation
resource "launchdarkly_custom_role" "view-project" {
  key              = "view-${local.project.key}"
  name             = "View - ${local.project.name}"
  description      = "Can view the project and its flags, but cannot make changes."
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}"]
    actions   = concat(["viewProject"], var.viewers_can_request_changes ? ["createApprovalRequest"] : [])
  }
}

resource "launchdarkly_custom_role" "flag-manager" {
  key              = "flag-manager-${local.project.key}"
  name             = "Flag Manager - ${local.project.name}"
  description      = "May perform flag management actions that do not impact the evaluation of existing flags."
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}"]
    actions   = ["viewProject"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}"]
    actions   = ["viewProject"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/*:flag/*"]
    actions   = concat([
      /* 
       *  Always include createApprovalRequest to prevent
       *  unintended consequences if you remove it from view project
       */
        "createApprovalRequest",
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
      ], var.with_separate_variation_manager == false ? [
        "updateFlagVariations"
      ] : [])
  }
  dynamic "policy_statements" {
    for_each = var.with_separate_context_manager == false ? toset([{
      effect    = "allow"
      resources = ["proj/${local.project.specifier}:context-kind/*"]
      actions   = ["createContextKind", "updateContextKind", "updateAvailabilityForExperiments"]
    }]) : toset([])
    content {
      effect    = policy_statements.value.effect
      resources = policy_statements.value.resources
      actions   = policy_statements.value.actions
    }
  }
}

resource "launchdarkly_custom_role" "context-manager" {
  key              = "context-manager-${local.project.key}"
  name             = "Context Manager - ${local.project.name}"
  description      = "May create and update context kinds"
  base_permissions = "no_access"
    policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}"]
    actions   = ["viewProject"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:context-kind/*"]
    actions   = ["createContextKind", "updateContextKind", "updateAvailabilityForExperiments"]
  }
}

resource "launchdarkly_custom_role" "flag-archiver" {
  key              = "archiver-${local.project.key}"
  name             = "Archiver - ${local.project.name}"
  description      = "May archive flags but not delete them. This action impacts the evaluation of existing flags in all environments. It can, however, be easily undone."
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}"]
    actions   = ["viewProject"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/*:flag/*"]
    actions   = ["updateGlobalArchived"]
  }
}

resource launchdarkly_custom_role "variation-manager" {
  count = var.with_separate_variation_manager ? 1 : 0
  key              = "varmgr-${local.project.key}"
  name             = "Variation Manager - ${local.project.name}"
  description      = "Impacts evaluation of existing flags in all environments"
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}"]
    actions   = ["viewProject"]
  }
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
    resources = ["proj/${local.project.specifier}"]
    actions   = ["viewProject"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/*:flag/*"]
    actions   = ["updateClientSideFlagAvailability"]
  }
}
