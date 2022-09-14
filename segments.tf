
resource "launchdarkly_segment" "automated-test" {

  key         = "supported-platform"
  project_key = launchdarkly_project.project.key
  env_key     = "test"
  name        = "Supported Platform"
  description = "Users who are on supported device or browser"
  tags        = ["platform", "managed-by-presenter"]
 

  rules {
    clauses {
      attribute = "CircleCI"
      op        = "in"
      values    = [true]
      negate    = false
    }
  }
  rules {
    clauses {
      attribute = "Hostname"
      op        = "icn"
      values    = [true]
      negate    = false
    }
  }
}


resource "launchdarkly_segment" "supported_platforms" {

  key         = "supported-platform"
  name        = "Supported Platform"
  project_key = launchdarkly_project.project.key
  env_key     = "production"
  description = "Users who are currently using a supported platform. We consider anything older than 3 major versions behind stable a legacy platform"
  tags        = ["platform", "managed-by-frontend"]

  rules {
    clauses {
      attribute = "Android: Version"
      op        = "semVerGreaterThan"
      values    = ["12.0.0"]
      negate    = false
    }
  }
  rules {
    clauses {
      attribute = "iOS: Version"
      op        = "semVerGreaterThan"
      values    = ["11.0.0"]
      negate    = false
    }
  }
  rules {
    clauses {
      attribute = "Browser"
      op        = "in"
      values    = ["firefox"]
      negate    = false
    }
    clauses {
      attribute = "Browser: Version"
      op        = "semVerGreaterThan"
      values    = ["50.0.0"]
      negate    = false
    }
  }
}

resource launchdarkly_segment "internal-accounts" {
  rules {
    clauses {
      attribute = "Account ID"
      op = "in"
      values = ["1A03169E-00E3-420D-A0DA-8032BA9DB093", "F6509262-8C7F-4362-9FF3-7620FA1794FB", "FE0E3B72-5A0F-4CF1-8D7F-159F400CA1B2"]
    }
  }
}

