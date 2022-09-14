

resource "launchdarkly_feature_flag_environment" "db_create_table_widget" {
 flag_id = launchdarkly_feature_flag.db_create_table_widget.id
 env_key =  "test"
 targeting_enabled = true
 flag_fallthrough {
    variation = 0
 }
}

resource "launchdarkly_feature_flag_environment" "release_widget_backend" {
 flag_id = launchdarkly_feature_flag.release_widget_api.id
 env_key =  "test"
 targeting_enabled = true
  prerequisites {
    flag_key = launchdarkly_feature_flag.db_create_table_widget.key
    variation = 0
  }
  flag_fallthrough {
    variation = 0
  }
}

resource "launchdarkly_feature_flag_environment" "release_widget" {
 flag_id = launchdarkly_feature_flag.release_widget.id
 env_key =  "test"
 targeting_enabled = false

 prerequisites {
    flag_key  = launchdarkly_feature_flag.release_widget_api.key
    variation = 0
  }

  rules {
      clauses {
            negate = false
        attribute = "Groups"
        op = "in"
        values = ["staff"]
      }
    variation = 1
  }
  rules {
      clauses {
            negate = false
        attribute = "EAP Opt-Ins"
        op = "in"
        values = ["widget"]
      }
      clauses {
        negate = true
        attribute = "segmentMatch"
        op = "segmentMatch"
        values = [launchdarkly_segment.legacy_platforms.key]
      }
    variation = 1
  }
  
  flag_fallthrough {
      variation = 1
  }
}
resource "launchdarkly_feature_flag_environment" "show_unsupported_platform_banner" {
  
  flag_id = launchdarkly_feature_flag.show_unsupported_platform_banner.id
  env_key = "test"
  targeting_enabled =  true
  rules {
    clauses {
      op = "segmentMatch"
      attribute = "segmentMatch"
      values = [launchdarkly_segment.legacy_platforms.key]
      negate = false
    }
  }
  flag_fallthrough {
    variation = 1
  }
}

resource "launchdarkly_feature_flag_environment" "release_widget_platform" {
  for_each = launchdarkly_feature_flag.release_widget_platform
  flag_id = each.value.id
  env_key = "test"
  targeting_enabled =  true
  prerequisites {
    flag_key = launchdarkly_feature_flag.release_widget.key 
    variation = 0 
  }

}


resource "launchdarkly_feature_flag_environment" "show_table_row" {
 flag_id = launchdarkly_feature_flag.show_table_row.id
 env_key =  "test"
 targeting_enabled = true

  rules {
      clauses {
            negate = false
        attribute = "Flag Key"
        op = "startsWith"
        values = ["release-"]
      }
    variation = 1
  }
  rules {
      clauses {
            negate = false
        attribute = "Flag Key"
        op = "contains"
        values = ["-widget"]
      }
    variation = 1
  }
rules {
      clauses {
            negate = false
        attribute = "Flag Key"
        op = "startsWith"
        values = ["db-"]
      }
    variation = 1
  }
  rules {
      clauses {
            negate = false
        attribute = "Flag Key"
        op = "startsWith"
        values = ["db-"]
      }
    variation = 1
  }
  rules {
      clauses {
            negate = false
        attribute = "Flag Key"
        op = "startsWith"
        values = ["migrate-"]
      }
    variation = 0
  }

 rules {
      clauses {
            negate = false
        attribute = "Calculated Row"
        op = "in"
        values = ["Available EAPs"]
      }
    variation = 0
  }

  flag_fallthrough {
      variation = 0
  }



}

resource "launchdarkly_feature_flag_environment" "config_table_cell_symbol" {
    flag_id = launchdarkly_feature_flag.config_table_cell_symbol.id
    env_key = "test"
    targeting_enabled = true
    
    flag_fallthrough {
      variation = 0
    }

    off_variation = 0
}

locals {
  rollout_flag_variations = {for index, variation in launchdarkly_feature_flag.config_rollout_flag.variations: variation.value => index}
}
resource "launchdarkly_feature_flag_environment" "config_rollout_flag" {
    flag_id = launchdarkly_feature_flag.config_rollout_flag.id
    env_key = "test"
    targeting_enabled = true
    
    flag_fallthrough {
      variation = local.rollout_flag_variations["release-widget"]
    }

    off_variation = local.rollout_flag_variations["release-widget"]
}
resource "launchdarkly_feature_flag_environment" "config_table_cell_color" {
    flag_id = launchdarkly_feature_flag.config_table_cell_color.id
    env_key = "test"
    targeting_enabled = true
    rules {
        clauses {
            negate = false
            attribute = "Flag Value"
            op = "in"
            value_type = "boolean" 
            values = [true]    
        }
        variation = 0
    }
    rules {
      clauses {
            negate = false
            attribute = "Flag Value"
            op = "in"
            value_type = "boolean" 
            values = [false]    
        }
        variation = 1
    }

    flag_fallthrough {
      variation = 0
    }
    
    off_variation = 0
}

locals {
  logVerbosity = { for key, info in launchdarkly_feature_flag.config_log_verbosity.variations : info.name => key }
}
resource "launchdarkly_feature_flag_environment" "config_log_verbosity" {
    flag_id = launchdarkly_feature_flag.config_log_verbosity.id
    env_key =  "test"
    off_variation = local.logVerbosity["Warning"]
    targeting_enabled = true
    flag_fallthrough {
      variation = local.logVerbosity["Warning"]
    }
  
}


