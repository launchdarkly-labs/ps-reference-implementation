
resource launchdarkly_feature_flag "release-dashboard-v2" {
    name        = "Release: Dashboard v2"
    key         = "release-dashboard-v2"
    project_key = launchdarkly_project.project.key
    description = "Keystone flag for all subcomponents of the Dashboard v2 feature."
    tags = ["early-access-program","managed-by-product", "managed-by-presenter", "demo", "pattern-example", "keystone"]
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
    tags = ["managed-by-backend", "incident-response", "managed-by-presenter", "demo", "pattern-example", "example-has-dependencies", "example-uses-keystone"]
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
    tags        = ["managed-by-frontend","demo", "example-pattern", "example-has-keystone", "example-cross-project"]
    temporary        = true
    variations {
        name = "Available"
        value = true
        description = "dashboard-live-charts is available to users"
    }
    variations {
        name = "Unavailable"
        value = false
        description = "dashboard-live-charts is unavailable to users"
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
  

resource "launchdarkly_feature_flag" "allow_eap_dashboardv2" {
    project_key = launchdarkly_project.project.key
    key = "allow-eap-dashboard-v2"
    name = "Allow: Early Access Program : Dashboard v2"
    description = "Allows Users to view and opt-in to the Dashboard v2 Early Access Program"
    variation_type = "boolean"
    tags = ["managed-by-product", "demo", "example-pattern"]
    temporary = true
    variations {
            name = "Allow Opt-In"
            value = true
            description = "User will be able to see and opt in to this early access program. "
        }
    variations {
            name = "Deny Opt-In"
            value = false
            description = "User will be unable to opt-in to this early program. Users who are not already opted-in will be not see the access program."
        }
    
  include_in_snippet = true
  default_on_variation = true
  default_off_variation = false
}
  

resource "launchdarkly_feature_flag" "config_table_cell_color" {
    project_key = launchdarkly_project.project.key
    key = "config-table-cell-color"
    name = "Config: Table Cell Color"
    description = "Controls the color of the cells in the Rollout Display Table"
    variation_type = "string"
    tags = ["managed-by-presenter", "user-interface", "rollout-table"]
    temporary = false
    variations {
            name = "Green"
            value = "green"
            description = ""
        }
    variations {
            name = "Blue"
            value = "blue"
            description = ""
        }
    variations {
            name = "Red"
            value = "red"
            description = ""
        }
    variations {
            name = "Cyan"
            value = "cyan"
            description = ""
        }
    variations {
            name = "Yellow"
            value = "yellow"
            description = ""
        }
    variations {
            name = "Magenta"
            value = "magenta"
            description = ""
        }
    variations {
            name = "Black"
            value = "black"
            description = ""
        }
    variations {
        name = "LD Blue"
        value = "#228be6"
    }
    variations {
        name ="LD Blue"
        value = "#00b969"
    }
  include_in_snippet = true
  default_on_variation = "red"
  default_off_variation = "red"
}
  

resource "launchdarkly_feature_flag" "config_table_cell_symbol" {
    project_key = launchdarkly_project.project.key
    key = "config-table-cell-symbol"
    name = "Config: Table Cell Symbol"
    description = "Controls the symbol used in the Rollout Display table. Must be one character, preferably mono-width."
    variation_type = "string"
    tags = ["managed-by-presenter", "user-interface", "rollout-table"]
    temporary = false
    variations {
            name = "Block"
            value = "█"
            description = ""
        }
    variations {
            name = "Happy"
            value = "🙂"
            description = ""
        }
    variations {
            name = "Sad"
            value = "🙁"
            description = ""
        }
    variations {
            name = "Sssh!"
            value = "🤫"
            description = ""
        }
    variations {
            name = "Party"
            value = "🎉"
            description = ""
        }
    
  include_in_snippet = true
  default_on_variation = "█"
  default_off_variation = "█"
}
  

resource "launchdarkly_feature_flag" "db_create_table_widget" {
    project_key = launchdarkly_project.project.key
    key = "db-create-table-widget"
    name = "DB: Create Table: Widget"
    description = "Serves true after the schema change is applied and the table is available for use "
    variation_type = "boolean"
    tags = ["managed-by-dba"]
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
  

resource "launchdarkly_feature_flag" "show_table_row" {
    project_key = launchdarkly_project.project.key
    key = "show-table-row"
    name = "Show: Table Row"
    description = "Controls which table rows are displayed in the demo"
    variation_type = "boolean"
    tags = ["managed-by-presenter", "user-interface", "rollout-table"]
    temporary = false
    variations {
            name = "Show"
            value = true
            description = "Row will be shown"
        }
    variations {
            name = "Hide"
            value = false
            description = "Row will be hidden"
        }
    
  include_in_snippet = true
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
    tags = ["demo", "example-pattern", "example-has-dependencies"]
}


locals {
    // get a map of flag keys and names for rollout flag variations
    config_rollout_flags = { for flag in flatten([
            // standalone flags
            [  
                launchdarkly_feature_flag.release_dashboard_v2,
                launchdarkly_feature_flag.release_widget_api,
                launchdarkly_feature_flag.config_log_verbosity,
                launchdarkly_feature_flag.allow_eap_dashboardv2,
            ],
            // for_each/group flags
            [ for group in [launchdarkly_feature_flag.release_widget_platform] :  [
                for key,value in group: value]
            ]
        ]): flag.key => flag.name 
    }
}

resource "launchdarkly_feature_flag" "config_rollout_flag" {
    project_key = launchdarkly_project.project.key
    key = "config-rollout-flag"
    name = "Config: Rollout Flag"
    description = "Sets the flag displayed in the Rollout Table. Docs: <https://example.com/rollout-display-table#config-rollout-flag>"
    variation_type = "string"
    tags = ["managed-by-presenter", "user-interface", "rollout-table"]
    temporary = false

    dynamic "variations" {
        for_each = local.config_rollout_flags
        content {
            name = variations.value
            value = variations.key
            }
    }


     
     
  include_in_snippet = true
  default_on_variation = "release-dashboard-v2"
  default_off_variation = "release-dashboard-v2"
}

