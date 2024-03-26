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

module "preproduction-production-roles" {
  source = "./roles/flag-lifecycle"
  project = {
    key  = "pandora-test-project"
    name = "Pandora Test Project"
  }
  environments = {
    // the map key is used to generate role keys
    // for example: flag-maintainer-default-preproduction
    "preproduction" = {
      // the key defines the specifier
      key = "preproduction"
      specifier = "*;{critical:false}"
      name = "Preproduction"
    },
    "production" = {
      key = "production"
      specifier = "*;{critical:true}"
      name = "Production"
    }
  }
}
