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

  # aws
  # transform aws instances object into expected nested structure
  instances_aws_transform = {
    for instance in var.instances_aws : lookup(instance.tags, "Name", instance.id) => merge(
      { "ansible_host" = instance.private_ip },
      instance.tags
    )
  }

  # google
  # transform gcp instances object into expected nested structure
  instances_gcp_transform = {
    for instance in var.instances_gcp : instance.name => merge(
      { "ansible_host" = instance.network_interface.0.network_ip },
      { for tag in instance.tags : regexall("[-\\w]+", tag)[0] => regexall("[-\\w]+", tag)[1] if length(regexall("[-\\w]+", tag)) == 2 }
    )
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

  # vsphere
  # transform vsp instances object into expected nested structure
  instances_vsp_transform = {
    for instance in var.instances_vsp : instance.name => merge(
      { "ansible_host" = instance.default_ip_address },
      try({ "ansible_become_user" = instance.clone.0.customize.0.windows_options.0.full_name }, {}),
      try(instance.vapp[0].properties, {})
    )
  }
}
