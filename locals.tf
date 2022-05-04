locals {
  # inventory content
  inv_content = {
    for format in var.formats : format => templatefile(
      "${path.module}/templates/inventory.${format}.tmpl",
      { instances = local.instances_transform }
    )
  }

  # merge transformed instances inputs and transform to overall expected structure
  instances_transform = {
    "all" = {
      "hosts" = merge(
        local.instances_aws_transform,
        local.instances_gcp_transform,
        local.instances_azr_transform,
        local.instances_vsp_transform,
        local.instances_var_transform
      )
    }
  }

  # transform instances input into expected nested structure
  instances_var_transform = {
    for instance in var.instances : instance.name =>
    merge({ "ansible_host" = instance.ip }, instance.vars)
  }

  # transform aws instances object into expected nested structure
  instances_aws_transform = {
    for instance in var.instances_aws : lookup(instance.tags, "Name", instance.id) => merge({ "ansible_host" = instance.private_ip }, instance.tags)
  }

  # transform gcp instances object into expected nested structure
  instances_gcp_transform = {
    for instance in var.instances_gcp : instance.name => merge({ "ansible_host" = instance.network_interface.0.network_ip }, { for tag in instance.tags : regexall("[-\\w]+", tag)[0] => regexall("[-\\w]+", tag)[1] if length(regexall("[-\\w]+", tag)) == 2 })
  }

  # transform azr instances object into expected nested structure
  instances_azr_transform = {
    for instance in var.instances_azr : instance.name => merge({ "ansible_host" = instance.private_ip_address }, instance.tags)
  }

  # transform vsp instances object into expected nested structure
  instances_vsp_transform = {
    for instance in var.instances_vsp : instance.name => merge({ "ansible_host" = instance.default_ip_address }, try(instance.vapp[0].properties, {}))
  }
}
