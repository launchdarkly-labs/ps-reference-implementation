output "project-roles" {
  description = "Project-level experimentation roles"
  value = {
    "experiment-manager" = launchdarkly_custom_role.experiment-manager
  }
}

output "environment-roles" {
  description = "Environment-level experimentation roles"
  value = {
    for env_key, env in local.environments: env_key => {
      for role_key, role in launchdarkly_custom_role.metric-manager: role_key => role[env_key]
    }
  }
}

resource launchdarkly_custom_role "experiment-manager" {
  for_each = local.environments
  key              = "exp-mgr-${local.project.key}-${each.key}"
  name             = "Experiment Manager: ${valocalr.project.key}"
  description      = "Can create and manage experiments in ${local.project.name} / ${each.value.name}"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.specifier}:env/${each.value.specifier}:experiment/*"]
    actions   = ["*"]
  }
  dynamic "policy_statements" {
    for_each = local.denied_environments[each.key]
    content {
      effect    = "deny"
      resources = ["proj/${local.project.specifier}:env/${policy_statements.value.specifier}:metric/*"]
      actions   = ["*"]
    }
  }
}


resource launchdarkly_custom_role "metric-manager" {
  key              = "metric-mgr-${local.project.key}"
  name             = "Metric Manager: ${local.project.name}"
  description      = "Can perform all actions on metrics in ${local.project.name}"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.specifer}:metric/*"]
    actions   = ["*"]
  }
}

