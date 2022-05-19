locals {
  # custom
  # transform instances input into expected nested structure
  instances_var_transform = {
    for instance in var.instances : instance.name =>
    merge(
      { "ansible_host" = instance.ip },
      instance.vars
    )
  }

  # construct instances groups
  instances_var_groups = {
    "custom" = {
      "hosts" = length(var.instances) > 0 ? local.instances_var_transform : {}
    }
  }

  # aws
  # transform aws instances object into expected nested structure
  instances_aws_transform = {
    for instance in var.instances_aws : lookup(instance.tags, "Name", instance.id) => merge(
      { "ansible_host" = instance.private_ip },
      instance.tags
    )
  }

  # construct aws instances groups
  instances_aws_groups = {
    "aws" = {
      "hosts" = length(var.instances_aws) > 0 ? local.instances_aws_transform : {}
    }
  }

  # google
  # transform gcp instances object into expected nested structure
  instances_gcp_transform = {
    for instance in var.instances_gcp : instance.name => merge(
      { "ansible_host" = instance.network_interface.0.network_ip },
      { for tag in instance.tags : regexall("[-\\w]+", tag)[0] => regexall("[-\\w]+", tag)[1] if length(regexall("[-\\w]+", tag)) == 2 }
    )
  }

  # construct gcp instances groups
  instances_gcp_groups = {
    "gcp" = {
      "hosts" = length(var.instances_gcp) > 0 ? local.instances_gcp_transform : {}
    }
  }

  # azure
  # transform azr instances object into expected nested structure
  instances_azr_transform = {
    for instance in var.instances_azr : instance.name => merge(
      { "ansible_host" = instance.private_ip_address },
      { "ansible_become_user" = try(instance.admin_ssh_key.0.username, instance.admin_username) },
      instance.tags
    )
  }

  # construct azure instances groups
  instances_azr_groups = {
    "azr" = {
      "hosts" = length(var.instances_azr) > 0 ? local.instances_azr_transform : {}
    }
  }

  # vsphere
  # transform vsp instances object into expected nested structure
  instances_vsp_transform = {
    for instance in var.instances_vsp : instance.name => merge(
      { "ansible_host" = instance.default_ip_address },
      try({ "ansible_become_user" = instance.clone.0.customize.0.windows_options.0.full_name }, {}),
      try(instance.vapp[0].properties, {})
    )
  }

  # construct vsp instances groups
  instances_vsp_groups = {
    "vsp" = {
      "hosts" = length(var.instances_vsp) > 0 ? local.instances_vsp_transform : {}
    }
  }

  # all
  # merge all groups
  instances_groups = merge(
    local.instances_var_groups,
    local.instances_aws_groups,
    local.instances_gcp_groups,
    local.instances_azr_groups,
    local.instances_vsp_groups
  )
}
