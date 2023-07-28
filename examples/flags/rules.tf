variable "production_environment_key" {
  type        = string
  description = "LaunchDarkly production environment"
  default     = "production"
  required = true
}

variable "production" {
  type = object({
    key = string
  })
  default = {
    key = "production"
  }
  description = "LaunchDarkly production environment"
  required = true
}

variable "preproduction" {
  type = object({
    key = string
  })
  default = {
    key = "test"
  }
  description = "LaunchDarkly pre-production environment"
  required = true
}
  


locals {
    environments = [var.preproduction.key, var.production.key]
}

resource "launchdarkly_feature_flag_environment" "db_create_table_widget" {
 for_each = local.environments
 flag_id = launchdarkly_feature_flag.db_create_table_widget.id
 env_key =  each.value
 on = true
 fallthrough {
    variation = 0
 }
}

resource "launchdarkly_feature_flag_environment" "release_widget_api" {
 for_each = local.environments
 flag_id = launchdarkly_feature_flag.release_widget_api.id
 env_key =  each.value
 on = true
  prerequisites {
    flag_key = launchdarkly_feature_flag.db_create_table_widget.key
    variation = 0
  }
  fallthrough {
    variation = 0
  }
}

resource "launchdarkly_feature_flag_environment" "release_dashboard_v2" {
 flag_id = launchdarkly_feature_flag.release_dashboard_v2.id
 env_key =  var.production.key
 on = false

  rules {
      clauses {
        negate = false
        attribute = "Groups"
        op = "in"
        values = ["staff"]
      }
    variation = 0
  }

  rules {
      clauses {
        negate = false
        attribute = "segmentMatch"
        op = "segmentMatch"
        values = [launchdarkly_segment.dashboard_eap.key]
      }
    variation = 0
  }

  rules {
    clauses {
      op = "segmentMatch"
      attribute = "segmentMatch"
      values = [launchdarkly_segment.supported_platforms]
    }
    rollout_weights = [10000 , 90000]
  }
  fallthrough {
      variation = 1
  }
}

resource "launchdarkly_feature_flag_environment" "show_unsupported_platform_banner" {
  
  flag_id = launchdarkly_feature_flag.show_unsupported_platform_banner.id
  env_key = var.production.key
  on =  true
  rules {
    clauses {
      op = "segmentMatch"
      attribute = "segmentMatch"
      values = [launchdarkly_segment.supported_platforms.key]
      negate = true
    }
    variation = 0
  }
  fallthrough {
    variation = 1
  }
}

resource "launchdarkly_feature_flag_environment" "release_widget_platform_android" {
  for_each = launchdarkly_feature_flag.release_widget_platform
  flag_id = each.value.id
  env_key = var.preproduction.key
  on =  true
  prerequisites {
    flag_key = launchdarkly_feature_flag.release_widget_api.key 
    variation = 0 
  }
  rules {
    clauses {
      op = "segmentMatch"
      attribute = "segmentMatch"
      values = [launchdarkly_segment.supported_platforms.key]
      negate = true
    }
    variation = 0
  }
}

resource "launchdarkly_feature_flag_environment" "release_widget_platform" {
  for_each = launchdarkly_feature_flag.release_widget_platform
  flag_id = each.value.id
  env_key = var.production.key
  on =  true
  prerequisites {
    flag_key = launchdarkly_feature_flag.release_widget_api.key 
    variation = 0 
  }
  rules {
    clauses {
      attribute = "Build: Version"
      op = "semVerGreaterThan"
      values = ["26.2.0"]
    }
    variation = 0
  }
}






locals {
  logVerbosity = { for key, info in launchdarkly_feature_flag.config_log_verbosity.variations : info.name => key }
}

resource "launchdarkly_feature_flag_environment" "config_log_verbosity" {
    flag_id = launchdarkly_feature_flag.config_log_verbosity.id
    env_key =  var.preproduction.key
    off_variation = local.logVerbosity["Warning"]
    on = true
    rules {
      
    }
    fallthrough {
      variation = local.logVerbosity["Debug"]
    }
}

resource "launchdarkly_feature_flag_environment" "config_log_verbosity" {
    flag_id = launchdarkly_feature_flag.config_log_verbosity.id
    env_key =  var.preproduction.key
    off_variation = local.logVerbosity["Warning"]
    on = true
    fallthrough {
      variation = local.logVerbosity["Debug"]
    }
}

resource "launchdarkly_feature_flag_environment" "config_log_verbosity" {
    flag_id = launchdarkly_feature_flag.config_log_verbosity.id
    env_key =  var.preproduction.key
    off_variation = local.logVerbosity["Warning"]
    on = true
    rules {
      clauses {
        op = "endsWith"
        attribute = "email"
        values = "@wearehackerone.com"
      }
    }
    fallthrough {
      variation = local.logVerbosity["Warning"]
    }
}

resource "launchdarkly_feature_flag_environment" "release_live_metrics_api" {
  flag_id = launchdarkly_flag.release_live_metrics_api
  env_key = var.production.key
  on = true
  rules {
    clauses {
      attribute = "API: Version"
      op = "semVerGreaterThan"
      values = ["2.0.0"]
    }
    variation = 0
  }
  fallthrough {
    variation = 1
  }
}
resource "launchdarkly_feature_flag_environment" "release_live_metrics_api" {
  flag_id = launchdarkly_flag.release_live_metrics_api
  env_key = var.test.key
  on = true
  fallthrough {
    variation = 0
  }
  
}

