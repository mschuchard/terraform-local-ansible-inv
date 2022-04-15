resource "local_file" "ansible_inventory" {
  for_each = var.formats

  content = templatefile(
    "${path.module}/templates/inventory.${each.value}.tmpl",
    {
      # need to separate because ternary demands same type structure
      instances_ini  = local.instances_transform,
      instances_mark = local.instances_transform
    }
  )

  # prefix inventory with name of first instance for now
  filename        = "${path.root}/${var.prefix}inventory.${each.value}"
  file_permission = "0644"
}
