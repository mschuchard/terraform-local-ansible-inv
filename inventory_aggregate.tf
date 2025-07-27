locals {
  # inventory string content per format specification
  inv_content = {
    for format in var.formats : format => templatefile(
      "${path.module}/templates/inventory.${format}.tmpl",
      { instances = local.instances_transform }
    )
  }

  # aggregate transformed components, and transform again to overall expected structure
  instances_transform = {
    "all" = {
      "hosts"    = {},
      "children" = local.instances_groups,
      # lookup function incompatible with map(any) type
      "vars" = try(var.group_vars["all"], {})
    }
  }

  # merge all custom and platform groups
  instances_groups = merge(
    local.instances_var_groups,
    # refrain from adding any empty platform groups, but note this also would need to be updated if a platform group children feature is added
    length(local.instances_aws_groups["aws"]["hosts"]) > 0 ? local.instances_aws_groups : {},
    length(local.instances_gcp_groups["gcp"]["hosts"]) > 0 ? local.instances_gcp_groups : {},
    length(local.instances_azr_groups["azr"]["hosts"]) > 0 ? local.instances_azr_groups : {},
    length(local.instances_vsp_groups["vsp"]["hosts"]) > 0 ? local.instances_vsp_groups : {}
  )
}
