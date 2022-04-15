locals {
  # transform instances input into expected structure for yaml and json
  instances_transform = {
    "all" = {
      "hosts" = {
        for instance in var.instances : instance.name =>
        merge({ "ansible_host" = instance.ip }, instance.vars)
      }
    }
  }

  # transform aws instances object into expected structure for yaml and json
  aws_instances_transform = {}
}
