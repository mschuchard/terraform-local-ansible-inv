output "ini" {
  value       = "TODO"
  description = "The Ansible INI format inventory content."
}

output "yaml" {
  value       = yamlencode(local.instances_transform)
  description = "The Ansible YAML format inventory content."
}

output "json" {
  value       = jsonencode(local.instances_transform)
  description = "The Ansible JSON format inventory content."
}
