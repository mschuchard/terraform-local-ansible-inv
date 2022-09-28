output "ini" {
  value       = contains(var.formats, "ini") ? local_file.ansible_inventory["ini"].content : ""
  description = "The Ansible INI format inventory content."
}

output "yaml" {
  value       = contains(var.formats, "yaml") ? local_file.ansible_inventory["yaml"].content : ""
  description = "The Ansible YAML format inventory content."
}

output "json" {
  value       = contains(var.formats, "json") ? local_file.ansible_inventory["json"].content : ""
  description = "The Ansible JSON format inventory content."
}

output "inv_files" {
  value       = [for file in local_file.ansible_inventory : file.filename]
  description = "The list of inventory file output paths."
}
