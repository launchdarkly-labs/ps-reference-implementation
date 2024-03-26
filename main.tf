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
  // map of environments keys (as defined above) to environment keys 
  # environment_excludes = {
  #   "preproduction" = [ "production" ]
  # }
}

/* 
 * Create teams for a project
 * Edit the per-project team definitions in teams/per-project/teams.tf
 */

module default-project-teams {
  source = "./teams/per-project"
  role-definitions = module.gemini_roles
  project = {
    key  = "default"
    name = "Default project"
  }
  role-definitions = module.default-project-roles
}

# module project-example {
#   source = "./projects/simple"
# }
