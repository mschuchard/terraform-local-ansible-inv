resource "local_file" "ansible_inventory" {
  for_each = var.formats

  content = local.inv_content[each.value]
  # prefix inventory with name of first instance for now
  filename        = "${path.root}/${var.prefix}inventory.${each.value}"
  file_permission = var.inv_file_perms
}
