resource "local_file" "ansible_inventory" {
  for_each = var.manage_file ? var.formats : []

  content = local.inv_content[each.value]
  # prefix inventory with variable value
  filename        = "${path.root}/${var.prefix}inventory.${each.value}"
  file_permission = var.inv_file_perms
}
