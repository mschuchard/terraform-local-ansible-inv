locals {
  # transform instances input into expected structure for yaml and json
  instances_transform = {
    "all" = {
      "hosts" = merge(local.aws_instances_transform, local.var_instances_transform)
    }
  }

  # transform instances input into expected structure for yaml and json
  var_instances_transform = {
    for instance in var.instances : instance.name =>
    merge({ "ansible_host" = instance.ip }, instance.vars)
  }

  # transform aws instances object into expected structure for yaml and json
  aws_instances_transform = {
    for instance in var.aws_instances : lookup(instance.tags, "Name", instance.id) => merge({ "ansible_host" = instance.private_ip }, instance.tags)
  }
}
