output "ini" {
  value       = contains(var.formats, "ini") ? local.inv_content["ini"] : null
  description = "The Ansible INI format inventory content."
}

output "yaml" {
  value       = contains(var.formats, "yaml") ? local.inv_content["yaml"] : null
  description = "The Ansible YAML format inventory content."
}

output "json" {
  value       = contains(var.formats, "json") ? local.inv_content["json"] : null
  description = "The Ansible JSON format inventory content."
}

output "inv_files" {
  value       = [for file in local_file.ansible_inventory : file.filename]
  description = "The list of inventory file output paths."
}
