
data launchdarkly_team_members maintainers {
    emails = var.maintainers
}


module developers {
    source = "../simple"
    role-definitions = var.role-definitions
    maintainer_ids = data.launchdarkly_team_members.maintainers.team_members[*].id

    name = "${var.project.name} - Developers"
    key = "${var.project.key}-developers"
    description = "Developers with access to ${var.project.name} project"
    project-roles = ["view-project", "flag-manager"]
    environment-roles = {
      "test": ["sdk-key", "release-manager", "approver", "segment-manager", "apply-changes", "trigger-manager"],
      "production": ["release-manager"]
    }
}

module sr-developers {
    source = "../simple"
    role-definitions = var.role-definitions
    maintainer_ids = data.launchdarkly_team_members.maintainers.team_members[*].id
    name = "${var.project.name} - Sr. Developers"
    key = "${var.project.key}-sr-developers"
    description = "Developers with access to ${var.project.name} project"
    project-roles = ["view-project", "flag-manager", "sdk-manager"]
    environment-roles = {
      "test": ["sdk-key", "release-manager", "approver", "segment-manager", "apply-changes", "trigger-manager"],
      "production": ["release-manager", "apply-changes", "segment-manager"]
    }
}

module qa {
    source = "../simple"
    role-definitions = var.role-definitions
    maintainer_ids = data.launchdarkly_team_members.maintainers.team_members[*].id

    name = "${var.project.name} - QA"
    key = "${var.project.key}-qa"
    description = "Developers with access to ${var.project.name} project"
    project-roles = ["view-project"]
    environment-roles = {
      "test": ["sdk-key", "release-manager", "approver", "segment-manager", "apply-changes", "trigger-manager"],
      "production": ["release-manager"]
    }
}


module product-manager {
    source = "../simple"
    role-definitions = var.role-definitions
    maintainer_ids = data.launchdarkly_team_members.maintainers.team_members[*].id

    name = "${var.project.name} - Product Managers"
    key = "${var.project.key}-product-managers"
    description = "Product Managers with access to ${var.project.name} project"
    project-roles = ["view-project", "flag-archiver", "sdk-manager"]
    environment-roles = {
      "test": ["sdk-key", "release-manager", "approver", "segment-manager", "apply-changes", "trigger-manager"],
      "production": ["release-manager", "approver", "sdk-key"]
    }
}

module sre {
    source = "../simple"
    role-definitions = var.role-definitions
    maintainer_ids = data.launchdarkly_team_members.maintainers.team_members[*].id

    name = "${var.project.name} - SRE"
    key = "${var.project.key}-sre"
    description = "Product Managers with access to ${var.project.name} project"
    project-roles = ["view-project"]
    environment-roles = {
      "test": ["sdk-key", "release-manager", "approver", "segment-manager", "apply-changes", "trigger-manager"],
      "production": ["release-manager", "apply-changes", "approver", "sdk-key"]
    }
}