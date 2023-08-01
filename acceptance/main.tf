# declare module to provision inventory files
module "ansible_inv" {
  source = "../"

  formats        = local.formats
  instances      = local.instances_var
  instances_aws  = local.instances_aws
  instances_gcp  = local.instances_gcp
  instances_azr  = local.instances_azr
  instances_vsp  = local.instances_vsp
  group_vars     = local.group_vars
  extra_hostvars = local.extra_hostvars
}

# validate generated inventory files with ad hoc ansible
resource "terraform_data" "inventory_validation" {
  for_each = local.formats

  triggers_replace = {
    ini_inventory  = module.ansible_inv.ini,
    yaml_inventory = module.ansible_inv.yaml,
    json_inventory = module.ansible_inv.json
  }

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
output "inventory_files" {
  value = module.ansible_inv.inv_files
}
