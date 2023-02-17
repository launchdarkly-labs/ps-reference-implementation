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
    key  = "global"
    name = "All projects"
  }
  // you can use project_specifier to create projet roles
  // that match wildcards and tags. it will be used to generate specifiers 
  // for example: proj/* or proj/default
  // defaults to project.key
  project_specifier = "*"

  environments = {
    "test" = {
      name = "Test"
    },
    "production" = {
      name = "Production"
    }
    "all" = {
       name = "All environments"
    }
    "preproduction" = {
      name = "Preproduction"
    },


  }
  // works like project_specifer but for environments
  environment_specifiers = {
    "all" = "*"
    "preproduction" = "*"
  }
  // allows you insert deny statements into roles generated environments
  // value should be a list of keys from var.environments
  environment_excludes = {
    "preproduction" = ["production"]
  }
}



