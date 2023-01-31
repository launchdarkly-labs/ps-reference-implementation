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

module "default-project-roles" {
  source = "./project-roles"
  project = {
    key  = "default"
    name = "Default"
  }

  environments = {
    "test" = {
      name = "Test"
    },
    "production" = {
      name = "Production"
    }
  }
}


*/