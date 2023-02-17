terraform {
  required_providers {
    launchdarkly = {
      source  = "launchdarkly/launchdarkly"
      version = "~> 2.0"

    }
  }


  required_version = "~> 1.1.6"
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


/* Example: Create per-project roles using the project-roles module

*/

module "global-project-roles" {
  source = "./roles/flag-lifecycle"
  // project.key will be used in the generated role keys
  // for example: flag-manager-global
  project = {
    key  = "*"
    name = "All projects"
  }
  // if not specified, project.key will be used
  role_key = "global"

  environments = {
    "test" = {
      key = "test"
      name = "Test"
    },
    "production" = {
      key = "production"
      name = "Production"
    }
    "all" = {
       key = "*"
       name = "All environments"
    }
    "preproduction" = {
      key = "*"
      name = "Preproduction"
    }
  }
  // allows you insert deny statements into roles generated environments
  // value should be a list of keys from var.environments
  environment_excludes = {
    "preproduction" = ["production"]
  }
}



