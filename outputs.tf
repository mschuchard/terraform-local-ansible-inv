output "ini" {
  value = contains(var.formats, "ini") ? templatefile(
    "${path.module}/templates/inventory.ini.tmpl",
    { instances = local.instances_transform }
  ) : ""
  description = "The Ansible INI format inventory content."
  depends_on  = [local_file.ansible_inventory]
}

output "yaml" {
  value = contains(var.formats, "yaml") ? templatefile(
    "${path.module}/templates/inventory.yaml.tmpl",
    { instances = local.instances_transform }
  ) : ""
  description = "The Ansible YAML format inventory content."
  depends_on  = [local_file.ansible_inventory]
}

output "json" {
  value = contains(var.formats, "json") ? templatefile(
    "${path.module}/templates/inventory.json.tmpl",
    { instances = local.instances_transform }
  ) : ""
  description = "The Ansible JSON format inventory content."
  depends_on  = [local_file.ansible_inventory]
}
