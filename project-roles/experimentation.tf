
launchdarkly_custom_role "experiment-manager" {
  key              = "${var.project.key}-exp-manager"
  name             = "${var.project.key} Experiment Manager"
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


launchdarkly_custom_role "experiment-maintainer" {
  for_each         = var.environments
  key              = "${var.project.key}-exp-maintainer-${each.key}"
  name             = "${var.project.name} Experiment Maintainer: ${each.value.name}"
  description      = "Can create, start, stop, and delete experiments in a single environment"
  base_permissions = "no_access"

  policy_statements {
    effect    = "allow"
    resources = ["proj/${var.project.key}:env/${each.value.key}:experiment/*"]
    actions   = ["createExperimentIteration", "deleteExperimentIteration", "deleteExperimentResults", "updateExperimentIteration", "updateExperimentIterationActive"]

  }
}
  
