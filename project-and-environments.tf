resource "launchdarkly_project" "project" {
  key  = var.project_key
  name = var.project_name
  include_in_snippet  = true
  tags = setunion(["reference-project"], var.additional_tags)
  environments {
        key   = "test"
        name  = "Test"
        require_comments = false
        confirm_changes = false
        color = "f5a623"
        tags  = []
    }
    environments {
        key   = "production"
        name  = "Production"
        require_comments = false
        confirm_changes = false
        color = "00ff00"
        tags  = []
    }
}





