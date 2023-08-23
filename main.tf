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


/* Example: Create per-project roles using the project-roles module */
module "default-project-roles" {
  source = "./roles/flag-lifecycle"
  project = {
    key  = "default"
    name = "Default project"
  }
  // allows flag managers to update flag variations, only enable if at least one env enforces approvals
  // with_separate_variation_manager = true 
  // enable/disable createApprovalRequest in view role, defaults to true
  // viewers_can_request_changes = false
  environments = {
    "test" = {
      key = "test"
      name = "Test"
    },
    "production" = {
      key = "production"
      name = "Production"
    }
  }
}

/* Example: Create roles for projects matching a prefix */
module "sandbox-prefix-project-roles" {
  source = "./roles/flag-lifecycle"
  project = {
    key  = "sandbox-*"
    name = "Sandbox projects"
  }
  // `role_key` is appended to generated role keys
  // we need to set it since `sandbox-*` is not a valid role key
  // example roles: flag-manager-sandbox, archiver-sandbox, etc
  role_key = "sandbox"
  with_separate_variation_manager = false 
  environments = {
    "test" = {
      key = "test"
      name = "Test"
    },
    "production" = {
      key = "production"
      name = "Production"
    }
  }
}

/* Example: Create roles for preproduction/production using wildcards and denies */
/*
module "preproduction-production-roles" {
  source = "./roles/flag-lifecycle"
  project = {
    key  = "default"
    name = "Default project"
  }
  with_separate_variation_manager = false 
  environments = {
    // the map key is used to generate role keys
    // for example: flag-maintainer-default-preproduction
    "preproduction" = {
      // the key defines the specifier
      key = "*"
      name = "Preproduction"
    },
    "production" = {
      key = "production"
      name = "Production"
    }
  }
  // map of environments keys (as defined above) to environment kets 
  environment_excludes = {
    "preproduction" = [ "production" ]
  }
}*/

/* 
 * Create teams for a project
 * Edit the per-project team definitions in teams/per-project/teams.tf
 */
/*
module default-project-teams {
  source = "./teams/per-project"
  project = {
    key  = "default"
    name = "Default project"
  }
  role-definitions = module.default-project-roles
}

module project-example {
  source = "./projects/simple"
}
*/
