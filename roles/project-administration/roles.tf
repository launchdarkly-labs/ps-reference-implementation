
output "project-roles" {
  description = "Project-level administration roles"
    value = {
        "admin" = launchdarkly_custom_role.workspace-admin
    }
}

resource launchdarkly_custom_role "workspace-admin" {
  key              = "admin-${local.project.key}"
  name             = "Project Admin - ${local.project.name}"
  description      = "All actions relating to projects/environments including potentially destructive ones such as delete project"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}:env/*:destination/*"]
    actions   = ["*"]

  }

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}:env/*"]
    actions   = ["*"]

  }

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}:env/*:flag/*"]
    actions   = ["deleteFlag", "updateFlagSalt"]

  }

  policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}"]
    actions   = ["*"]
  }

   policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}:release-pipeline/*"]
    actions   = ["*"]
  }

   policy_statements {
    effect    = "allow"
    resources = ["proj/${local.project.key}"]
    actions   = ["*"]
  }
}
