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


/* Example: Create roles for preproduction/production using wildcards and denies */

module "gemini_project_roles" {
  source = "./roles/flag-lifecycle"
  project = {
    key  = "gemini"
    name = "Gemini"
  }
  environments = {
    // the map key is used to generate role keys
    // for example: flag-maintainer-default-preproduction
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

module "gemini_project_teams" {
  source = "./teams/per-project"
  role-definitions = module.gemini_roles
  project = {
    key  = "pandora-test-project"
    name = "Pandora Test Project"
  }
}

module "pos_project_teams" {
  source = "./teams/per-project"
  role-definitions = module.pos_roles
  project = {
    key  = "pos"
    name = "POS"
  }
}

resource launchdarkly_custom_role "platform_admin" {
  key              = "platform-admin"
  name             = "Platform Admin"
  description      = "Platform admins"
  base_permissions = "reader"
  policy_statements {
    effect    = "allow"
    resources = ["acct"]
    actions   = ["*"]
  }
  policy_statements {
    effect    = "allow"
    resources = ["teams/*"]
    actions   = ["*"]
  
  }
  policy_statements {
    effect    = "allow"
    resources = ["custom-roles/*"]
    actions   = ["*"]
  }
}