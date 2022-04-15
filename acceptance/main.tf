# declare module to provision inventory files
module "ansible_inv" {
  source = "../"

  formats       = local.formats
  instances     = local.var_instances
  aws_instances = local.aws_instances
}

# validate generated inventory files with ad hoc ansible
resource "null_resource" "inventory_validation" {
  for_each = local.formats

  triggers = { inventory = module.ansible_inv.yaml }

  provisioner "local-exec" {
    command = "ansible all -i inventory.${each.value} -m ping"
  }
}

# inspect outputs
output "inventory_ini" {
  value = module.ansible_inv.ini
}
output "inventory_yaml" {
  value = module.ansible_inv.yaml
}
output "inventory_json" {
  value = module.ansible_inv.json
}
