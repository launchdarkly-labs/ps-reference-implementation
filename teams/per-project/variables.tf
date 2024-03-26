variable "project" {
  description = "LaunchDarkly project to create teams for"
  type = object({
    name = string
    key  = string
  })
}
variable maintainers {
    description = "List of LaunchDarkly member e-mails to add as maintainers"
    type = set(string)
    default = []
}

variable "role-definitions" {
    description = "Inventory of role definitions from the roles module"
    type = object({
            project-roles = map(
                object({
                    key = string
                })
            ),
        environment-roles = map(map(
            object({
            key = string
            })
        ))
    })
}
