locals {
  # inventory string content per format
  inv_content = {
    for format in var.formats : format => templatefile(
      "${path.module}/templates/inventory.${format}.tmpl",
      { instances = local.instances_transform }
    )
  }

  # merge transformed components and transform to overall expected structure
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
}
