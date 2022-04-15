# declare module to provision inventory files
module "ansible_inv" {
  source = "../"

  formats = local.formats
  instances = [
    {
      name = "localhost"
      ip   = "127.0.0.1"
      vars = { "ansible_connection" = "local" }
    },
    {
      name = "also_localhost"
      ip   = "127.0.0.1"
      vars = { "ansible_connection" = "local", "foo" = "bar" }
    }
  ]
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
