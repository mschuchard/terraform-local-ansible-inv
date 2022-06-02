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
      "hosts"    = {},
      "children" = local.instances_groups,
      # lookup function incompatible with map(any) type
      "vars" = try(var.group_vars["all"], {})
    }
  }
}
