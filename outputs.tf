output "ini" {
  value       = contains(var.formats, "ini") ? file("${path.root}/${var.prefix}inventory.ini") : ""
  description = "The Ansible INI format inventory content."
}

output "yaml" {
  value       = contains(var.formats, "yaml") ? file("${path.root}/${var.prefix}inventory.yaml") : ""
  description = "The Ansible YAML format inventory content."
}

output "json" {
  value       = contains(var.formats, "json") ? file("${path.root}/${var.prefix}inventory.json") : ""
  description = "The Ansible JSON format inventory content."
}
