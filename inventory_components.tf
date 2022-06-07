locals {
  # custom
  # transform instances input into expected nested structure and also construct instances groups
  instances_var_groups = {
    # iterate through map and construct map of group to string "hosts"
    for group, instances in var.instances : group => {
      # construct map of string "hosts" to set of instance objects
      "hosts" = {
        # iterate through set of instance objects and transform into expected ansible inventory structure
        # structure is map of instance name to host variable values object
        for instance in instances : instance.name =>
        merge(
          { "ansible_host" = instance.ip },
          instance.vars
        )
      },
      # add vars for this group if they exist
      # lookup function incompatible with map(any) type
      "vars" = try(var.group_vars[group], {})
    }
  }

  # aws
  # transform aws instances object into expected nested structure
  instances_aws_transform = {
    for instance in var.instances_aws : lookup(instance.tags, "Name", instance.id) => merge(
      { "ansible_host" = instance.private_ip },
      try(instance.tags, {}),
      can(instance.password_data) ? { "ansible_transport" = "winrm" } : {}
    )
  }

  # construct aws instances groups
  instances_aws_groups = {
    "aws" = {
      "hosts" = length(var.instances_aws) > 0 ? local.instances_aws_transform : {},
      # lookup function incompatible with map(any) type
      "vars" = try(var.group_vars["aws"], {})
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
      "hosts" = length(var.instances_gcp) > 0 ? local.instances_gcp_transform : {},
      # lookup function incompatible with map(any) type
      "vars" = try(var.group_vars["gcp"], {})
    }
  }

  # azure
  # transform azr instances object into expected nested structure
  instances_azr_transform = {
    for instance in var.instances_azr : instance.name => merge(
      { "ansible_host" = instance.private_ip_address },
      { "ansible_become_user" = try(instance.admin_ssh_key.0.username, instance.admin_username) },
      try(instance.tags, {}),
      can(regex("Windows", instance.source_image_reference.0.offer)) ? { "ansible_transport" = "winrm" } : {}
    )
  }

  # construct azure instances groups
  instances_azr_groups = {
    "azr" = {
      "hosts" = length(var.instances_azr) > 0 ? local.instances_azr_transform : {},
      # lookup function incompatible with map(any) type
      "vars" = try(var.group_vars["azr"], {})
    }
  }

  # vsphere
  # transform vsp instances object into expected nested structure
  instances_vsp_transform = {
    for instance in var.instances_vsp : instance.name => merge(
      { "ansible_host" = instance.default_ip_address },
      try({ "ansible_become_user" = instance.clone.0.customize.0.windows_options.0.full_name }, {}),
      try(instance.vapp[0].properties, {}),
      can(instance.clone.0.customize.0.windows_options) ? { "ansible_transport" = "winrm" } : {}
    )
  }

  # construct vsp instances groups
  instances_vsp_groups = {
    "vsp" = {
      "hosts" = length(var.instances_vsp) > 0 ? local.instances_vsp_transform : {},
      # lookup function incompatible with map(any) type
      "vars" = try(var.group_vars["vsp"], {})
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
