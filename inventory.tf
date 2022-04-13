resource "local_file" "ansible_inventory" {
  for_each = var.formats

  content = templatefile(
    "${path.module}/templates/inventory.${each.value}.tmpl",
    {
      # need to separate because ternary demands same type structure
      instances_ini  = var.instances,
      instances_mark = local.instances_transform
    }
  )

  # prefix inventory with name of first instance for now
  filename        = "${path.root}/inventory.${each.value}"
  file_permission = "0644"
}

locals {
  # transform instances input into expected structure for yaml and json
  instances_transform = {
    "all" = {
      "hosts" = {
        for instance in var.instances : instance.name => {
          "ansible_host" = instance.ip
        }
      }
    }
  }
}
