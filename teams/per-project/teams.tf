data launchdarkly_team_members maintainers {
    emails = var.maintainers
}

module developers {
    source = "../simple"
    role-definitions = var.role-definitions
    maintainer_ids = data.launchdarkly_team_members.maintainers.team_members[*].id

    name = "${var.project.name} - Developers"
    key = "${var.project.key}-developers"
    description = "Developers with access to the ${var.project.name} project"
    project-roles = ["view-project", "flag-manager"]
    environment-roles = {
      "*;{critical:false}": ["sdk-key", "release-manager", "segment-manager"]
    }
}

module architects_and_leads {
    source = "../simple"
    role-definitions = var.role-definitions
    maintainer_ids = data.launchdarkly_team_members.maintainers.team_members[*].id
    name = "${var.project.name} - Architects and Leads"
    key = "${var.project.key}architects-and-leads"
    description = "Architects & Leads with access to the ${var.project.name} project"
    project-roles = ["view-project", "flag-manager", "sdk-manager"]
    environment-roles = {
      "*;{critical:false}": ["sdk-key", "release-manager", "segment-manager", "approver", "apply-changes", "trigger-manager"],
      "*;{critical:true}": ["sdk-key", "release-manager", "segment-manager", "approver", "apply-changes", "trigger-manager"]
    }
}

module qa {
    source = "../simple"
    role-definitions = var.role-definitions
    maintainer_ids = data.launchdarkly_team_members.maintainers.team_members[*].id

    name = "${var.project.name} - QA"
    key = "${var.project.key}-qa"
    description = "QA with access to the ${var.project.name} project"
    project-roles = ["view-project"]
    environment-roles = {
      "*;{critical:false}": ["release-manager", "segment-manager"]
    }
}

module product_owners {
    source = "../simple"
    role-definitions = var.role-definitions
    maintainer_ids = data.launchdarkly_team_members.maintainers.team_members[*].id

    name = "${var.project.name} - Product Owners"
    key = "${var.project.key}-product-owners"
    description = "Product Owners with access to the ${var.project.name} project"
    project-roles = ["view-project"]
    environment-roles = {
      "*;{critical:false}": ["release-manager", "segment-manager"],
      "*;{critical:true}": ["release-manager", "segment-manager"]
    }
}