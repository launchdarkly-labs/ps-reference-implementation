
output "project-roles"{
    description = "Project-level flag lifecycle management roles"
    value = merge(
    {
        "view_project" = launchdarkly_custom_role.view_project,
        "create_update_flags" = launchdarkly_custom_role.create_update_flags,
        "archive_flags" = launchdarkly_custom_role.archive_flags,
        "update_client_side_availability" = launchdarkly_custom_role.update_client_side_availability,
    }, var.seperate_update_flag_variations_role ? {
        "update_flag_variations" = launchdarkly_custom_role.update_flag_variations[0]
    } : {})
}

/// Read only access to a subset of projects
/// May create approval requests.
/// Rationale: Empower any team to request changes to the application. May be scoped with a tag. Think requesting user impersonation
resource "launchdarkly_custom_role" "view_project" {
  key              = "view-project-${var.key}"
  name             = "View Project - ${local.name}"
  description      = "Can view the project and its flags, but cannot make changes."
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = local.include_project_specifiers
    actions   = concat(["viewProject"], var.viewers_can_request_changes ? ["createApprovalRequest"] : [])
  }
  dynamic "policy_statements" {
    for_each = local.exclude_project_specifiers
    content {
      effect    = "deny"
      resources = policy_statements.value
      actions   = ["*"]
    }
  }
}

resource "launchdarkly_custom_role" "create_update_flags" {
  key              = "create-update-flags-${var.key}"
  name             = "Create Flags / Update Metadata - ${local.name}"
  description      = "Create and update global flag metadata. Can not perform actions that impact evaluation of existing flags"
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = local.include_project_specifiers
    actions   = "viewProject"
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
    for_each = var.seperate_manage_contexts_role == false ? toset([{
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

resource "launchdarkly_custom_role" "manage_context_kinds" {
  key              = "manage-context-kinds-${var.key}"
  name             = "Manage Context Kinds - ${local.name}"
  description      = "May create and update context kinds"
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}"]
    actions   = "viewProject"
  }
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:context-kind/*"]
    actions   = ["createContextKind", "updateContextKind", "updateAvailabilityForExperiments"]
  }
}

resource "launchdarkly_custom_role" "archive_flags" {
  key              = "archive-flags-${var.key}"
  name             = "Archive Flags - ${local.name}"
  description      = "May archive flags but not delete them. This action impacts the evaluation of existing flags in all environments. It can, however, be easily undone."
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}"]
    actions   = "viewProject"
  }
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/*:flag/*"]
    actions   = ["updateGlobalArchived"]
  }
}

resource launchdarkly_custom_role "update_flag_variations" {
  count = var.with_separate_variation_manager ? 1 : 0
  key              = "update-flag-variations-${var.key}"
  name             = "Variation Manager - ${local.name}"
  description      = "Impacts evaluation of existing flags in all environments"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/*:flag/*"]
    actions   = ["updateFlagVariations"]
  }
}


resource launchdarkly_custom_role "update_client_side_availability" {
  key              = "update-flag-avail-${var.key}"
  name             = "Update Flags - Client-side Availability - ${local.name}"
  description      = "Impacts the evaluation of flags in all environments for client-side SDKs"
  base_permissions = "no_access"
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}"]
    actions   = "viewProject"
  }
  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifier}:env/*:flag/*"]
    actions   = ["updateClientSideFlagAvailability"]

  }
}

