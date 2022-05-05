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
      "hosts" = local.instances_var_transform,
      "children" = {
        "aws" = {
          "hosts" = length(var.instances_aws) > 0 ? local.instances_aws_transform : {}
        }
        "gcp" = {
          "hosts" = length(var.instances_gcp) > 0 ? local.instances_gcp_transform : {}
        }
        "azr" = {
          "hosts" = length(var.instances_azr) > 0 ? local.instances_azr_transform : {}
        }
        "vsp" = {
          "hosts" = length(var.instances_vsp) > 0 ? local.instances_vsp_transform : {}
        }
      }
    }
  }
}
