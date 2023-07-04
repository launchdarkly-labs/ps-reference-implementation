resource "launchdarkly_project" "example" {
  key  = "example-project"
  name = "Example project"
  tags = [
    "managed-by-terraform",
  ]

  environments {
        key   = "production"
        name  = "Production"
        color = upper(substr(sha1("production"), 1,6))
        tags  = ["managed-by-terraform"]
        approval_settings {
            can_review_own_request = false
            can_apply_declined_changes = false
            min_num_approvals      = 1
        }
    }
  environments {
        key   = "qa"
        name  = "QA"
        color = upper(substr(sha1("qa"), 1,6))
        tags  = ["managed-by-terraform"]
    }
  environments {
        key   = "test"
        name  = "Test"
        color = upper(substr(sha1("test"), 1,6))
        tags  = ["managed-by-terraform"]
    }
}

module roles {
    source = "../../roles/flag-lifecycle"
    project = launchdarkly_project.example
    environments = {
        for env in launchdarkly_project.example.environments: env.key => {
            key = env.key
            name = env.name
        }
    }
}

module teams {
    source = "../../teams/per-project"
    project = launchdarkly_project.example
    role-definitions = module.roles
}