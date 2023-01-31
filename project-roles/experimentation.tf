
resource launchdarkly_custom_role "experiment-manager" {
  key              = "exp-manager-${var.project.key}"
  name             = "Experiment Manager: ${var.project.key}"
  description      = "Can create and manage experiments and metrics in all environments"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/*:experiment/*"]
    actions   = ["createExperiment", "createExperimentIteration", "deleteExperiment", "deleteExperimentIteration", "deleteExperimentResults", "updateExperimentDescription", "updateExperimentIteration", "updateExperimentIterationActive", "updateExperimentName"]

  }

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:metric/*"]
    actions   = ["createMetric", "deleteMetric", "updateDescription", "updateEventKey", "updateMaintainer", "updateName", "updateNumeric", "updateNumericSuccess", "updateNumericUnit", "updateOn", "updateSelector", "updateTags", "updateUrls"]
  }
}


resource launchdarkly_custom_role "experiment-maintainer" {
  for_each         = var.environments
  key              = "exp-maintainer-${var.project.key}-${each.key}"
  name             = "Experiment Maintainer: ${var.project.name} - ${each.value.name}"
  description      = "Can create, start, stop, and delete experiments in a single environment"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/${each.key}:experiment/*"]
    actions   = ["createExperimentIteration", "deleteExperimentIteration", "deleteExperimentResults", "updateExperimentIteration", "updateExperimentIterationActive"]

  }
}
  
