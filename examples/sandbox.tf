resource "launchdarkly_project" "sandbox" {
  key  = "sandbox"
  name = "Sandbox project"
  description = "Sandbox project for learning and testing"
  tags = [
    "managed-by-terraform"
  ]

  environments {
        key   = "production"
        name  = "Production"
        color = upper(substr(sha1("production"), 1,6))
        tags  = ["managed-by-terraform"]
        approval_settings {
            can_review_own_request = true
            can_apply_declined_changes = false
            min_num_approvals      = 1
        }
    }
  environments {
        key   = "test"
        name  = "Test"
        color = upper(substr(sha1("test"), 1,6))
        tags  = ["managed-by-terraform"]
    }
}

resource launchdarkly_custom_role sandbox {
    key = "sandbox-member"
    name = "Sandbox Member"
    description = "Can use and create sandbox projects"
    base_permissions = "no_access"
    policy_statements {
        effect = "allow"
        resources = ["proj/sandbox:env/flag/*", "proj/sandbox-*:env/flag/*"]
        actions = ["*"]
    }
    policy_statements {
        effect = "allow"
        resources = ["proj/sandbox:env/segment/*", "proj/sandbox-*:env/segment/*"]
        actions = ["*"]
    }
    policy_statements {
        effect = "allow"
        resources = ["proj/sandbox:env/metric/*", "proj/sandbox-*:env/metric/*"]
        actions = ["*"]
    }
    policy_statements {
        effect = "allow"
        resources = ["proj/sandbox:env/*:experiment/*", "proj/sandbox-*:env/*:experiment/*"]
        actions = ["*"]
    }
    policy_statements {
        effect = "allow"
        resources = ["proj/sandbox:env/*:experiment/*", "proj/sandbox-*:env/*:experiment/*"]
        actions = ["*"]
    }
    policy_statements {
      effect="allow"
      resources = ["proj/sandbox:env/*", "proj/sandbox-*:env/*"]
      actions = ["*"]
    }

    policy_statements {
      effect = "allow"
      resources = ["proj/sandbox", "proj/sandbox-*"]
      actions = ["*"]
    }

    policy_statements {
      effect = "deny"
      resources = ["proj/sandbox"]
      actions = ["deleteProject"]
    }

    policy_statements {
      effect = "deny"
      // in the original sandbox project, leave the original environments 
      resources = ["proj/sandbox:env/test","proj/sandbox:env/production"]
      actions = ["deleteEnvironment"]
    }
}