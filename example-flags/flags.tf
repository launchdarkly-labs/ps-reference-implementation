
variable "project" {
  type = object({
    name = string
    key  = string
  })
  description = "LaunchDarkly Project to create example flags in"
    required    = true
}

resource launchdarkly_feature_flag "release_dashboard_v2" {
    name        = "Release: Dashboard v2"
    key         = "release-dashboard-v2"
    project_key = launchdarkly_project.project.key
    description = "Keystone flag for all subcomponents of the Dashboard v2 feature."
    tags = ["early-access-program","managed-by-product", "managed-by-presenter", "demo", "example", "keystone", "dashboard-v2"]
    temporary        = true
    variations {
        name = "Available"
        value = true
        description = "dashboard-v2 is available to users"
    }
    variations {
        name = "Unavailable"
        value = false
        description = "dashboard-v2 is unavailable to users"
    default_on_variation = true
    default_off_variation = false
    }
}



  

resource "launchdarkly_feature_flag" "release_widget_api" {
    project_key = launchdarkly_project.project.key
    key = "release-widget-api"
    name = "Release: Widget API"
    description = "Controls availability of the Widget Backend APIs. Incident Response Runbook: <https://example.com>"
    variation_type = "boolean"
    tags = ["managed-by-backend", "incident-response", "managed-by-presenter", "demo", "example", "dependencies" ,"dashboard-v2"]
    temporary = true
    variations {
            name = "Available"
            value = true
            description = "Widget API is available to serve requests"
        }
    variations {
            name = "Unavailable"
            value = false
            description = "Widget API is unavailable. Requests will return 503"
        }
    
  include_in_snippet = true
  default_on_variation = true
  default_off_variation = false
}

resource launchdarkly_feature_flag "release-dashboard-live-charts" {
    name        = "Release: Dashboard: Live Charts"
    key         = "release-dashboard-live-charts"
    project_key = launchdarkly_project.default.key
    description = "Releases the live chart feature in Dashboard v2. Requires data aggregator service"
    tags        = ["managed-by-frontend","demo", "example", "dashboard-v2"]
    temporary        = true
    variations {
        name = "Available"
        value = true
        description = "Live Charts are available to users"
    }
    variations {
        name = "Unavailable"
        value = false
        description = "Live Charts are unavailable to users"
    default_on_variation = true
    default_off_variation = false
    }
}

resource launchdarkly_feature_flag "release_live_metrics_api" {
    name        = "Release: Live Metrics API"
    key         = "release-live-metrics-api"
    project_key = var.project.key
    description = "Release the live metrics API. Pretend this is in a seperate project "
    tags        = ["data-aggregator","demo", "example", "dashboard-v2"]
    temporary        = true
    variations {
        name = "Available"
        value = true
        description = "Live Metrics API is available to users"
    }
    variations {
        name = "Unavailable"
        value = false
        description = "Live Metrics API is unavailable to users"
        default_on_variation = true
        default_off_variation = false
    }
}

resource "launchdarkly_feature_flag" "config_log_verbosity" {
    project_key = launchdarkly_project.project.key
    key = "config-log-verbosity"
    name = "Config: Log Verbosity"
    description = "Controls the log verbosity of applications. Logs are aggregated in $service <http://example.com/logs>"
    variation_type = "string"
    tags = ["incident-response"]
    temporary = false
    variations {
            name = "Emergency"
            value = "emerg"
            description = "System is unusable"
        }
    variations {
            name = "Alert"
            value = "alert"
            description = "Action must be taken immediately. A condition that should be corrected immediately, such as a corrupted system database."
        }
    variations {
            name = "Critical"
            value = "crit"
            description = "Critical conditions"
        }
    variations {
            name = "Error"
            value = "error"
            description = "Error conditions"
        }
    variations {
            name = "Warning"
            value = "warn"
            description = "Warning conditions"
        }
    variations {
            name = "Notice"
            value = "notice"
            description = "Normal but significant conditions\t. Conditions that are not error conditions, but that may require special handling."
        }
    variations {
            name = "Info"
            value = "info"
            description = "Informational messages"
        }
    variations {
            name = "Debug"
            value = "debug"
            description = "Messages that contain information normally of use only when debugging a program."
        }
    
  include_in_snippet = true
  default_on_variation = "warn"
  default_off_variation = "warn"
}
  


  

resource "launchdarkly_feature_flag" "db_create_table_widget" {
    project_key = launchdarkly_project.project.key
    key = "db-create-table-widget"
    name = "DB: Create Table: Widget"
    description = "Serves true after the schema change is applied and the table is available for use "
    variation_type = "boolean"
    tags = ["managed-by-dba", "example", "delegated-authority"]
    temporary = true
    variations {
            name = "Table Available"
            value = true
            description = "Table has been created and is ready for use in this environment"
        }
    variations {
            name = "Table Unavailable"
            value = false
            description = "Table is unavailable"
        }
    
  include_in_snippet = false
  default_on_variation = true
  default_off_variation = false
}
  

resource "launchdarkly_feature_flag" "show_unsupported_platform_banner" {
    project_key = launchdarkly_project.project.key
    key = "show-unsupported-platform-banner"
    name = "Show: Unsupported Platform Banner"
    description = "Displays a banner warning users that their platform is unsupported. The will be able to dismiss the banner and continue using the application."
    variation_type = "boolean"
    tags = ["managed-by-presenter"]
    temporary = false
    variations {
            name = "Show"
            value = true
            description = "Banner will be shown"
        }
    variations {
            name = "Hide"
            value = false
            description = "Banner will be hidden"
        }
    
  include_in_snippet = true
  default_on_variation = false
  default_off_variation = false
}
  
resource "launchdarkly_feature_flag" "release_widget_platform" {
    for_each = {
        android = "Android"
        ios = "iOS"
        web = "Web"
    }
    
    project_key = launchdarkly_project.project.key
    key = "release-widget-${each.key}"
    name = "Release: Widget - ${each.value}"
    description = "Release Widget for ${each.value} users"
    variation_type = "boolean"
    tags = ["demo", "example"]
}


