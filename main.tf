terraform {
  required_providers {
    launchdarkly = {
      source = "launchdarkly/launchdarkly"
      version = "1.5.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
     time = {
      source = "hashicorp/time"
      version = "0.7.2"
  }
  }
 

  required_version = "~> 0.14.0"
}

variable "additional_tags" {
  type = set(string)
  default = []
}

variable "project_name" {
    type = string
    default = "Terminal Demo"
}

variable "project_key" {
  type = string
  default = "terminal-demo"
}



