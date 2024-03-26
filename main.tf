terraform {
  required_providers {
    launchdarkly = {
      source  = "launchdarkly/launchdarkly"
      version = "~> 2.0"
    }
  }
}

# Configure the LaunchDarkly provider
provider "launchdarkly" {
  access_token = var.launchdarkly_access_token
}

variable "launchdarkly_access_token" {
  type = string 
  sensitive = true
  description = "LaunchDarkly access token"
}


/* Custom roles for Gemini project */
module "gemini_roles" {
  source = "./roles/flag-lifecycle"
  project = {
    key  = "gemini"
    name = "Gemini"
  }
  environments = {
    "preproduction" = {
      // the key defines the specifier
      key = "*;{critical:false}"
      name = "Preproduction"
    },
    "production" = {
      key = "*;{critical:true}"
      name = "Production"
    }
  }
}

module "gemini_admin" {
  source = "./roles/project-administration"
  project = {
    key  = "gemini"
    name = "Gemini"
  }
  environments = {
    "preproduction" = {
      // the key defines the specifier
      key = "*;{critical:false}"
      name = "Preproduction"
    },
    "production" = {
      key = "*;{critical:true}"
      name = "Production"
    }
  }
}

/* 
 * Create teams for a Gemini project
 * Edit the per-project team definitions in teams/per-project/teams.tf
 */
module gemini_teams {
  source = "./teams/per-project"
  role-definitions = module.gemini_roles
  project = {
    key  = "gemini"
    name = "Gemini"
  }
}

/* Custom roles for Unified Commerce project */ 
module "unified_commerce_roles" {
  source = "./roles/flag-lifecycle"
  project = {
    key  = "unified-commerce"
    name = "Unified Commerce"
  }
  environments = {
    "preproduction" = {
      // the key defines the specifier
      key = "*;{critical:false}"
      name = "Preproduction"
    },
    "production" = {
      key = "*;{critical:true}"
      name = "Production"
    }
  }
}

module "unified_commerce_admin" {
  source = "./roles/project-administration"
  project = {
    key  = "unified-commerce"
    name = "Unified Commerce"
  }
  environments = {
    "preproduction" = {
      // the key defines the specifier
      key = "*;{critical:false}"
      name = "Preproduction"
    },
    "production" = {
      key = "*;{critical:true}"
      name = "Production"
    }
  }
}

/* 
 * Create teams for a Unified Commerce project
 * Edit the per-project team definitions in teams/per-project/teams.tf
 */
module unified_commerce_teams {
  source = "./teams/per-project"
  role-definitions = module.unified_commerce_roles
  project = {
    key  = "unified-commerce"
    name = "Unified Commerce"
  }
}

/* Custom roles for POS project */ 
module "pos_roles" {
  source = "./roles/flag-lifecycle"
  project = {
    key  = "pos"
    name = "POS"
  }
  environments = {
    "preproduction" = {
      // the key defines the specifier
      key = "*;{critical:false}"
      name = "Preproduction"
    },
    "production" = {
      key = "*;{critical:true}"
      name = "Production"
    }
  }
}

module "pos_admin" {
  source = "./roles/project-administration"
  project = {
    key  = "pos"
    name = "POS"
  }
  environments = {
    "preproduction" = {
      // the key defines the specifier
      key = "*;{critical:false}"
      name = "Preproduction"
    },
    "production" = {
      key = "*;{critical:true}"
      name = "Production"
    }
  }
}

/* 
 * Create teams for a POS project
 * Edit the per-project team definitions in teams/per-project/teams.tf
 */
module pos_teams {
  source = "./teams/per-project"
  role-definitions = module.pos_roles
  project = {
    key  = "pos"
    name = "POS"
  }
}

/* Global Platform Admin role & corresponding team */
resource "launchdarkly_custom_role" "platform_admin" {
  key = "platform-admin"
  name = "Platform Admin"
  description = "Global platform admin role"
  base_permissions = "reader"
  policy_statements {
    effect    = "allow"
    resources = ["acct"]
    actions   = ["*"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["team/*"]
    actions   = ["*"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["role/*"]
    actions   = ["*"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["application/*"]
    actions   = ["*"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["code-reference-repository/*"]
    actions   = ["*"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["integration/*"]
    actions   = ["*"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["service-token/*"]
    actions   = ["*"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["webhook/*"]
    actions   = ["*"]
  }
}

resource "launchdarkly_team" "platform_administrators_team" {
  key                   = "platform-administrators-team"
  name                  = "Platform Administrators Team"
  description           = "Team to manage shared platform resources"
  custom_role_keys      = ["platform-admin"]
}

/* Global Operations role & corresponding team */
resource "launchdarkly_custom_role" "operations" {
  key = "operations"
  name = "Operations"
  description = "Global operations role"
  base_permissions = "reader"
  policy_statements {
    effect    = "allow"
    resources = ["proj/*"]
    actions   = ["viewProject"]
  }
}

resource "launchdarkly_team" "operations_team" {
  key                   = "operations-team"
  name                  = "Operations Team"
  description           = "Operations team. View-only access."
  custom_role_keys      = ["operations"]
}
