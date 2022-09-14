resource "launchdarkly_feature_flag" "allow_internal_tools" {
    project_key = launchdarkly_project.term.key
    key = "allow-internal-tools"
    name = "Allow: Internal Tools"
    description = "Control access to internal tools"
    variation_type = "boolean"
    tags = ["managed-by-security"]
    temporary = false
    variations {
            name = "Allow"
            value = true
            description = "Access to internal tools is allowed"
        }
    variations {
            name = "Deny"
            value = false
            description = "Access to internal tools is denied"
        }
    
  include_in_snippet = true
  default_on_variation = false
  default_off_variation = false
}

resource "launchdarkly_feature_flag" "allow_user_impersonation" {
    project_key = launchdarkly_project.term.key
    key = "allow-user-impersonation"
    name = "Allow: User Impersonation"
    description = "Allows staff to start a read-only session as a customer. Support Team can request temporary access in production"
    variation_type = "boolean"
    tags = ["managed-by-support","require-approval-production", "demo"]
    temporary = false
    variations {
            name = "Allow"
            value = true
            
        }
    variations {
            name = "Deny"
            value = false
            
        }
    
  include_in_snippet = true
  default_on_variation = true
  default_off_variation = false
}

resource "launchdarkly_feature_flag_environment" "allow_internal_tools" {
    flag_id = launchdarkly_feature_flag.allow_internal_tools.id
    env_key = "test"
    targeting_enabled = true
    rules {
      clauses {
            negate = false
        attribute = "Groups"
        op = "in"
        values = ["staff"]
      }
        variation = 0
    }
    flag_fallthrough {
      variation = 1
    }

    off_variation = 1
}
resource "launchdarkly_feature_flag_environment" "allow_user_impersonation" {
    flag_id = launchdarkly_feature_flag.allow_user_impersonation.id
    env_key = "test"
    targeting_enabled = true
    prerequisites {
        flag_key = launchdarkly_feature_flag.allow_internal_tools.key
        variation = 0
    }
    rules {
      clauses {
            negate = false
        attribute = "Groups"
        op = "in"
        values = ["staff"]
      }
        variation = 0
    }
    flag_fallthrough {
      variation = 1
    }

    off_variation = 1
}