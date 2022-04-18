locals {
  # transform instances input into expected structure
  instances_transform = {
    "all" = {
      "hosts" = merge(
        local.instances_aws_transform,
        local.instances_gcp_transform,
        local.instances_var_transform
      )
    }
  }

  # transform instances input into expected structure
  instances_var_transform = {
    for instance in var.instances : instance.name =>
    merge({ "ansible_host" = instance.ip }, instance.vars)
  }

  # transform aws instances object into expected structure
  instances_aws_transform = {
    for instance in var.instances_aws : lookup(instance.tags, "Name", instance.id) => merge({ "ansible_host" = instance.private_ip }, instance.tags)
  }

  # transform gcp instances object into expected structure
  instances_gcp_transform = {
    for instance in var.instances_gcp : try(instance.tags[0], instance.instance_id) => merge({ "ansible_host" = instance.network_interface.0.network_ip }, { for idx, tag in instance.tags : "var${idx}" => tag })
  }
}
