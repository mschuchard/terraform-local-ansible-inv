output "ini" {
  value       = contains(var.formats, "ini") ? local.inv_content["ini"] : ""
  description = "The Ansible INI format inventory content."
}

output "yaml" {
  value       = contains(var.formats, "yaml") ? local.inv_content["yaml"] : ""
  description = "The Ansible YAML format inventory content."
}

output "json" {
  value       = contains(var.formats, "json") ? local.inv_content["json"] : ""
  description = "The Ansible JSON format inventory content."
}
